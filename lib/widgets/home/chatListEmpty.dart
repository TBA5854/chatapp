  import 'package:flutter/material.dart';

Widget ChatListEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No chats yet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a conversation by tapping the button below',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
