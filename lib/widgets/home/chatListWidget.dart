import 'package:chat/models/chat.dart';
import 'package:chat/helpers/formatTime.dart';
import 'package:flutter/material.dart';


Widget ChatListWidget({required List<Chat> chats, required String username}) {
  
    final Map<String, Chat> uniqueUserChats = {};

    for (var chat in chats) {
      final name = (chat.sender == username) ? chat.receiver : chat.sender;
      if (!uniqueUserChats.containsKey(name) ||
          chat.time.isAfter(uniqueUserChats[name]!.time)) {
        uniqueUserChats[name] = chat;
      }
    }

    final List<String> uniqueUsers = uniqueUserChats.keys.toList();

    return ListView.builder(
      itemCount: uniqueUsers.length,
      itemBuilder: (context, index) {
        final username = uniqueUsers[index];
        final latestChat = uniqueUserChats[username]!;

        return ListTile(
          leading: CircleAvatar(
            child: Text(username[0]),
          ),
          title: Text(username),
          subtitle: Text(
            latestChat.message,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(TimeHelper.formatTimestamp(latestChat.time)),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/chat',
              arguments: {
                'username': username,
                'chat': latestChat,
              },
            );
          },
        );
      },
    );
  }
