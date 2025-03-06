import 'package:chat/main.dart';
import 'package:chat/controllers/WsController.dart';
import 'package:chat/widgets/home/chatAlert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:chat/models/chat.dart';
import 'package:chat/widgets/home/chatListEmpty.dart';
import 'package:chat/widgets/home/chatListWidget.dart';

// Provider for chat data
final chatProvider = StateNotifierProvider<ChatNotifier, List<Chat>>((ref) {
  return ChatNotifier();
});

class ChatNotifier extends StateNotifier<List<Chat>> {
  final Box<Chat> _chatBox = Hive.box<Chat>('chatBox');
  ChatNotifier() : super([]) {
    state = _chatBox.values.toList();
    }
  
  

  void addMessage(Chat chat) {
    _chatBox.put(chat.messageId, chat);
    print("chat: ${_chatBox.values}");
    state = [chat, ...state];
  }

  void updateMessageId({required String newId, required String oldId}) {
    state = state.map((chat) {
      if (chat.messageId == oldId) {
        final updatedChat = chat.copyWith(messageId: newId);
        _chatBox.put(newId, updatedChat);
        _chatBox.delete(oldId);
        return updatedChat;
      }
      return chat;
    }).toList();
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late String usrname;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    usrname = username;
    WsController.listenToWebSocket(ref);
  }

  Future<void> _loadUsername() async {
    setState(() {
      usrname = username;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    final chats = ref.watch(chatProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: chats.isEmpty ? ChatListEmpty() : ChatListWidget(chats: chats, username: usrname),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showUsernameDialog(context);
        },
        child: const Icon(Icons.chat),
      ),
    );

 

  }
  void _showUsernameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => chatAlert(context),
    );
  }
  
}
