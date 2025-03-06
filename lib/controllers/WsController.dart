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

  static Future<void> connectWebSocket() async {
    try {
      final uri = Uri.parse('${dotenv.env['WS_URL']}/message');
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('AUTH-TOKEN') ?? '';

      _socket = await WebSocket.connect(
        uri.toString(),
        headers: {'x-auth-token': token},
      );

      print("Connected to WebSocket");
    } catch (e) {
      throw Exception('Failed to connect to WebSocket: $e');
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
      onDone: () => print('WebSocket closed'),
      onError: (error) => print('WebSocket error: $error'),
      cancelOnError: false,
    );
  }

  static dynamic receiveMessage(String data) {
    final Map<String, dynamic> msg = jsonDecode(data);
    print(msg);
    if (msg.containsKey('oldId') && msg.containsKey('newId')) {
      String newId = msg['newId'];
      String oldId = msg['oldId'];
      return IdUpdate(newId: newId, oldId: oldId);
    }
    // print(DateTime.parse(msg['time']));
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
      throw Exception('WebSocket not connected');
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
      print("Message sent");
    } catch (e) {
      throw Exception('Failed to send message: $e');
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
