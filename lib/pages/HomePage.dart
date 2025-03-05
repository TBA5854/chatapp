import 'package:chat/presenters/HomePresenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat/models/chat.dart';

// Provider for chat data
final chatProvider = StateNotifierProvider<ChatNotifier, List<Chat>>((ref) {
  return ChatNotifier();
});

class ChatNotifier extends StateNotifier<List<Chat>> {
  ChatNotifier() : super([]);

  void addMessage(Chat chat) {
    state = [chat, ...state]; // Adds new message to the list
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late String username;
  
  @override
  void initState() {
    super.initState();
    _loadUsername();
    HomePresenter.listenToWebSocket(ref);
  }
  
  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Anonymous';
    });
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final chats = ref.watch(chatProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: chats.isEmpty ? _buildEmptyState() : _buildChatList(chats),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to new chat screen
        },
        child: const Icon(Icons.chat),
      ),
    );
  }

  Widget _buildChatList(List<Chat> chats) {
    // Get unique usernames and their latest messages
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
          trailing: Text(_formatTimestamp(latestChat.time)),
          onTap: () {
            // TODO: Navigate to chat detail screen
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

  Widget _buildEmptyState() {
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
}
