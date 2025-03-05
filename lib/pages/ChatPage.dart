import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String contactName;
  
  const ChatPage({
    super.key, 
    this.contactName = "John Doe" 
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  ChatMessage? _replyingTo;

  @override
  void initState() {
    super.initState();
    // Add mock data
    _loadMockMessages();
  }

  void _loadMockMessages() {
    var mockMessages = [
      ChatMessage(id: '1', text: "Hey, how are you?", isMe: false),
      ChatMessage(id: '2', text: "I'm good, thanks! How about you?", isMe: true),
      ChatMessage(id: '3', text: "Doing well! Did you finish the project?", isMe: false),
      ChatMessage(id: '4', text: "Almost done, just need to fix a few bugs.", isMe: true),
      ChatMessage(id: '5', text: "Let me know if you need any help!", isMe: false),
    ];
    mockMessages[1].replyTo = mockMessages[0];
    
    setState(() {
      _messages.addAll(mockMessages);
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    final messageText = _messageController.text;
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    
    setState(() {
      _messages.add(
        ChatMessage(
          id: newId,
          text: messageText,
          isMe: true,
          replyTo: _replyingTo,
        ),
      );
      
      // Clear reply state
      _replyingTo = null;
      
      // Add a simulated response
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _messages.add(
              ChatMessage(
                id: '${newId}_response',
                text: "This is a response to: $messageText",
                isMe: false,
              ),
            );
          });
        }
      });
    });
    _messageController.clear();
  }
  
  void _setReplyMessage(ChatMessage message) {
    setState(() {
      _replyingTo = message;
    });
    FocusScope.of(context).requestFocus(FocusNode());
    _messageController.text = '';
  }
  
  void _cancelReply() {
    setState(() {
      _replyingTo = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contactName),
        actions: [
          CircleAvatar(
            child: Text(widget.contactName[0]),
            backgroundColor: Colors.blue.shade300,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return GestureDetector(
                  onLongPress: () => _setReplyMessage(message),
                  child: message,
                );
              },
            ),
          ),
          if (_replyingTo != null)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.grey[200],
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _replyingTo!.isMe ? 'You' : widget.contactName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _replyingTo!.text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _cancelReply,
                  )
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: _replyingTo != null 
                          ? 'Reply to message...' 
                          : 'Type a message...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0, 
                        vertical: 10.0,
                      ),
                    ),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.blue[700],
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

class ChatMessage extends StatelessWidget {
  final String id;
  final String text;
  final bool isMe;
  late ChatMessage? replyTo;

  ChatMessage({
    Key? key,
    required this.id,
    required this.text,
    required this.isMe,
    this.replyTo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: Text(
                'JD', // First letter of contact name
                style: TextStyle(color: Colors.blue[700]),
              ),
            ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (replyTo != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue[600] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          replyTo!.isMe ? 'You' : 'John Doe',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: isMe ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        Text(
                          replyTo!.text,
                          style: TextStyle(
                            fontSize: 14,
                            color: isMe ? Colors.white : Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.blue[700] : Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: isMe ? const Radius.circular(18) : const Radius.circular(4),
                      bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          if (isMe)
            CircleAvatar(
              backgroundColor: Colors.blue[700],
              child: const Icon(Icons.person, color: Colors.white),
            ),
        ],
      ),
    );
  }
}
