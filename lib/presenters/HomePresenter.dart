import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chat/models/chat.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePresenter {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl:
        dotenv.env['BACKEND_URL']!, // Replace with your actual API base URL
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  static Future<List<dynamic>> getUserChats(String userId) async {
    try {
      final response =
          await _dio.get('/chats', queryParameters: {'userId': userId});

      if (response.statusCode == 200) {
        return response.data['chats'];
      } else {
        throw Exception('Failed to load chats: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching chats: $e');
    }
  }

  static WebSocket? _socket;
  static final StreamController<Chat> _chatStreamController =
      StreamController<Chat>.broadcast();
  static Stream<Chat> get chatStream => _chatStreamController.stream;

  static Future<void> connectWebSocket() async {
    try {
      final uri = Uri.parse('${dotenv.env['WS_URL']!}/message');
      final pref = await SharedPreferences.getInstance();
      final token = //pref.getString('AUTH_TOKEN') ?? '';
      print(token);
      _socket = await WebSocket.connect(
        uri.toString(),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      _socket!.listen(
        (data) {
          final Map<String, dynamic> msg = jsonDecode(data);
          final chat = Chat(
            sender: msg['sender'],
            receiver: msg['reciever'],
            message: msg['message'],
            time: DateTime.parse(msg['time']),
            messageId: msg['messageId'] ?? '',
            repliedMessage: msg['replied_to'] ?? '',
            isSent: true,
          );
          _chatStreamController.add(chat);
        },
        onDone: () async {
          print('WebSocket closed, code: ${_socket?.closeCode}, reason: ${_socket?.closeReason}');
          
          // Wait a moment before reconnecting
          await Future.delayed(const Duration(seconds: 2));
          
          // Attempt to reconnect if not manually closed
          if (_socket?.closeCode == 1005 || _socket?.closeCode == 1001) {
            print('Attempting to reconnect...');
            try {
              await connectWebSocket();
              print('Successfully reconnected to WebSocket');
            } catch (e) {
              print('Failed to reconnect: $e');
            }
          }
        },
        onError: (error) => print('WebSocket error: $error'),
        cancelOnError: false,
      );
    } catch (e) {
      throw Exception('Failed to connect to WebSocket: $e');
    }
  }

  static Future<void> sendMessage(Chat chat) async {
    if (_socket == null || _socket!.readyState != WebSocket.open) {
      throw Exception('WebSocket not connected');
    }

    try {
      final msg = {
        'message': chat.message,
        'sender': chat.sender,
        'reciever': chat.receiver,
        'time': chat.time.toIso8601String(),
        'replied_to': chat.repliedMessage,
      };
      _socket!.add(jsonEncode(msg));
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  static Chat receiveMessage(String data) {
    final Map<String, dynamic> msg = jsonDecode(data);
    final chat = Chat(
      sender: msg['sender'],
      receiver: msg['reciever'],
      message: msg['message'],
      time: DateTime.parse(msg['time']),
      messageId: msg['messageId'] ?? '',
      repliedMessage: msg['replied_to'] ?? '',
      isSent: true,
    );
    _chatStreamController.add(chat);
    return chat;
  }

  static void closeWebSocket() {
    _socket?.close();
    _socket = null;
  }
}
