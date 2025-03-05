import 'package:chat/presenters/HomePresenter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatItem {
  final String id;
  final String title;
  final String lastMessage;
  final DateTime timestamp;

  ChatItem({
    required this.id,
    required this.title, 
    required this.lastMessage,
    required this.timestamp,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? authToken;
  List<ChatItem> chats = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    HomePresenter.connectWebSocket();
    _loadAuthTokenAndChats();
  }

  Future<void> _loadAuthTokenAndChats() async {
    setState(() {
      isLoading = true;
    });
    
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('X-Auth-Token');
    
    // TODO: Replace this with actual API call to fetch chats
    await _fetchMockChats();
    
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchMockChats() async {
    // Simulating API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock data - replace with actual chat fetching logic
    final mockChats = [
      ChatItem(
        id: '1',
        title: 'John Doe',
        lastMessage: 'Hey, how are you?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      ChatItem(
        id: '2',
        title: 'Jane Smith',
        lastMessage: 'Meeting at 3pm tomorrow',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ChatItem(
        id: '3',
        title: 'Team Chat',
        lastMessage: 'Alex: I finished the design',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
    
    setState(() {
      chats = mockChats;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : chats.isEmpty 
          ? _buildEmptyState() 
          : _buildChatList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to new chat screen
        },
        child: const Icon(Icons.chat),
      ),
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

  Widget _buildChatList() {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(chat.title[0]),
          ),
          title: Text(chat.title),
          subtitle: Text(
            chat.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(_formatTimestamp(chat.timestamp)),
          onTap: () {
            // TODO: Navigate to chat detail screen
          },
        );
      },
    );
  }
}