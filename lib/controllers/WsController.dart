import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chat/models/chat.dart';
import 'package:chat/pages/HomePage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WsController {
  static WebSocket? _socket;
  static final StreamController<Chat> _chatStreamController =
      StreamController<Chat>.broadcast();
  static Stream<Chat> get chatStream => _chatStreamController.stream;

  static final List<Chat> _pendingMessages = []; // Store unsent messages
  static bool _isReconnecting = false;
  static int _reconnectAttempts = 0;

  static Future<void> connectWebSocket({bool forceReconnect = false}) async {
    if (_socket != null && _socket!.readyState == WebSocket.open && !forceReconnect) {
      return; // Already connected
    }

    try {
      final uri = Uri.parse('${dotenv.env['WS_URL']}/message');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('AUTH-TOKEN') ?? '';

      _socket = await WebSocket.connect(
        uri.toString(),
        headers: {'x-auth-token': token},
      );

      print("Connected to WebSocket");
      _reconnectAttempts = 0; // Reset attempt count

      // Send any pending messages
      for (var message in _pendingMessages) {
        sendMessage(message);
      }
      _pendingMessages.clear();

      // listenToWebSocket();
    } catch (e) {
      print('Failed to connect to WebSocket: $e');
      _attemptReconnect();
    }
  }

  static void listenToWebSocket(WidgetRef ref) {
    if (_socket == null) return;

    _socket!.listen(
      (data) {
        final message = receiveMessage(data);
        if (message is Chat) {
          ref.read(chatProvider.notifier).addMessage(message);
          print("New message received: ${message.message}");
        } else if (message is IdUpdate) {
          print("");
          ref.read(chatProvider.notifier).updateMessageId(
                newId: message.newId,
                oldId: message.oldId,
              );
        }
      },
      onDone: () {
        print('WebSocket closed. Attempting to reconnect...');
        _attemptReconnect();
      },
      onError: (error) {
        print('WebSocket error: $error');
        _attemptReconnect();
      },
      cancelOnError: false,
    );
  }

  static void _attemptReconnect() {
    if (_isReconnecting) return;
    _isReconnecting = true;

    int delay = 2 * (_reconnectAttempts + 1); // Exponential backoff
    _reconnectAttempts++;

    Future.delayed(Duration(seconds: delay), () {
      print("Reconnecting... (Attempt $_reconnectAttempts)");
      _isReconnecting = false;
      connectWebSocket();
    });
  }

  static dynamic receiveMessage(String data) {
    final Map<String, dynamic> msg = jsonDecode(data);
    if (msg.containsKey('oldId') && msg.containsKey('newId')) {
      return IdUpdate(newId: msg['newId'], oldId: msg['oldId']);
    }
    return Chat(
      sender: msg['sender'],
      receiver: msg['reciever'],
      message: msg['message'],
      time: DateTime.parse(msg['time']),
      messageId: msg['message_id'] ?? '',
      repliedMessage: msg['replied_to'],
      isSent: true,
    );
  }

  static Future<void> sendMessage(Chat chat) async {
    if (_socket == null || _socket!.readyState != WebSocket.open) {
      print("WebSocket not connected. Storing message for later.");
      _pendingMessages.add(chat);
      _attemptReconnect();
      return;
    }

    try {
      final msg = jsonEncode({
        'message': chat.message,
        'sender': chat.sender,
        'reciever': chat.receiver,
        'message_id': chat.messageId,
        'replied_to': chat.repliedMessage,
      });

      _socket!.add(msg);
      print("Message sent: ${chat.message}");
    } catch (e) {
      print('Failed to send message: $e');
      _pendingMessages.add(chat);
      _attemptReconnect();
    }
  }

  static void closeWebSocket() {
    _socket?.close();
    _socket = null;
  }
}

class IdUpdate {
  final String newId, oldId;
  IdUpdate({required this.newId, required this.oldId});
}
