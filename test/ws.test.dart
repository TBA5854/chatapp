import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chat/models/chat.dart';

WebSocket? _socket;
final StreamController<Chat> _chatStreamController =
    StreamController<Chat>.broadcast();
Stream<Chat> get chatStream => _chatStreamController.stream;

Future<void> connectWebSocket() async {
  try {
    //wss://chatapp-backend-gq65.onrender.com
    final uri = Uri.parse('ws://localhost:4000/message');
    const token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFsZXhqb2huc29uIiwiaWF0IjoxNzQxMTgyNjM1LCJleHAiOjE3NTY3MzQ2MzV9.qh_JmSjkjxsfRTf2Tx-XdfocXtwpiuPBlmCXIfdCa20';
    _socket = await WebSocket.connect(
      uri.toString(),
      headers: {
        'x-auth-token': token,
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
        print(
            'WebSocket closed, code: ${_socket?.closeCode}, reason: ${_socket?.closeReason}');

        // await Future.delayed(const Duration(seconds: 2));

        // // Attempt to reconnect if not manually closed
        // if (_socket?.closeCode == 1005 || _socket?.closeCode == 1001) {
        //   print('Attempting to reconnect...');
        //   try {
        //     await connectWebSocket();
        //     print('Successfully reconnected to WebSocket');
        //   } catch (e) {
        //     print('Failed to reconnect: $e');
        //   }
        // }
      },
      onError: (error) => print('WebSocket error: $error'),
      cancelOnError: false,
    );
  } catch (e) {
    throw Exception('Failed to connect to WebSocket: $e');
  }
}

Future<void> sendMessage(Chat chat) async {
  if (_socket == null || _socket!.readyState != WebSocket.open) {
    throw Exception('WebSocket not connected');
  }

  try {
    final msg = {
      'message': chat.message,
      'sender': chat.sender,
      'reciever': chat.receiver,
    };
    _socket!.add(jsonEncode(msg));
    print("msg sent");
  } catch (e) {
    throw Exception('Failed to send message: $e');
  }
}

Chat receiveMessage(String data) {
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

void closeWebSocket() {
  _socket?.close();
  _socket = null;
}

void main() async {
  await connectWebSocket();
  chatStream.listen((chat) {
    print({"message":chat});
  });
  // while (true) {
  //   stdin.readLineSync();
  // await sendMessage(Chat(
  //   sender: 'alexjohnson',
  //   receiver: 'johndoe',
  //   message: 'Hello, how are you?',
  //   time: DateTime.now(),
  //   messageId: '',
  //   repliedMessage: null,
  // ));
  // }


  // await sendMessage(Chat(
  //   sender: 'johnalex',
  //   receiver: 'alexjohnson',
  //   message: 'I am fine, thank you!',
  //   time: DateTime.now(),
  // ));

  // await sendMessage(Chat(
  //   sender: 'alexjohnson',
  //   receiver: 'johnalex',
  //   message: 'That is great to hear!',
  //   time: DateTime.now(),
  // ));

  // await sendMessage(Chat(
  //   sender: 'johnalex',
  //   receiver: 'alexjohnson',
  //   message: 'Yes, it is!',
  //   time: DateTime.now(),
  // ));

  // closeWebSocket();
}
