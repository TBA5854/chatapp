import 'package:chat/pages/HomePage.dart';
import 'package:chat/controllers/WsController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat/models/chat.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/dracula.dart';

class ChatPage extends ConsumerStatefulWidget {
  final String contactName;

  const ChatPage({super.key, required this.contactName});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  String? reply;
  String? replyMessage;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Chat> get allChats => ref
      .watch(chatProvider)
      .where((chat) =>
          chat.sender == widget.contactName ||
          chat.receiver == widget.contactName)
      .toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final allChats = ref.watch(chatProvider);
    final chats = allChats
        .where((chat) =>
            chat.sender == widget.contactName ||
            chat.receiver == widget.contactName)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contactName),
        elevation: 2,
        backgroundColor: colorScheme.onPrimary,
        foregroundColor: colorScheme.primary,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
        ),
        child: Column(
          children: [
            Expanded(
              child: chats.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        final chat = chats[index];
                        final isMe = chat.sender != widget.contactName;

                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: _buildMessageBubble(chat, isMe, colorScheme),
                        );
                      },
                    ),
            ),
            if (reply != null) _buildReplyUI(colorScheme),
            _buildMessageInput(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyUI(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Replying to:",
                  style: TextStyle(
                      color: colorScheme.onSurfaceVariant, fontSize: 14),
                ),
                Text(
                  replyMessage ?? "",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: colorScheme.onSurfaceVariant),
            onPressed: () {
              setState(() {
                reply = null;
                replyMessage = null;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Chat chat, bool isMe, ColorScheme colorScheme) {
    bool isCodeBlock =
        chat.message.startsWith("```") && chat.message.endsWith("```");
    bool isInlineCode = chat.message.contains("`") && !isCodeBlock;

    // Extract language and code (assuming syntax like ```dart\ncode\n```)
    String? language;
    String code = chat.message;
    if (isCodeBlock) {
      final match =
          RegExp(r'```(\w*)\n([\s\S]+?)\n```').firstMatch(chat.message);
      if (match != null) {
        language = match.group(1)?.toLowerCase();
        code = match.group(2) ?? "";
      }
    }

    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.reply),
                title: const Text('Reply'),
                onTap: () {
                  setState(() {
                    reply = chat.messageId;
                    replyMessage = chat.message;
                    print("Replying to: $reply");
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Copy'),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: chat.message));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Message copied to clipboard')),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (chat.repliedMessage != null)
            Container(
              padding: const EdgeInsets.all(6),
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Reply: ${allChats.firstWhere((element) => element.messageId == chat.repliedMessage, orElse: () => Chat(messageId: "", message: "Not found", sender: "", receiver: "", time: DateTime.now(), repliedMessage: null)).message}",
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMe
                  ? colorScheme.primary
                  : colorScheme.onPrimaryFixedVariant,
              borderRadius: BorderRadius.circular(20).copyWith(
                bottomRight:
                    isMe ? const Radius.circular(0) : const Radius.circular(20),
                bottomLeft:
                    isMe ? const Radius.circular(20) : const Radius.circular(0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: isCodeBlock
                ? HighlightView(
                    code,
                    language: _getHighlightLanguage(language),
                    theme: Theme.of(context).brightness == Brightness.light
                        ? githubTheme
                        : draculaTheme,
                    padding: const EdgeInsets.all(8),
                    textStyle: const TextStyle(fontSize: 14),
                  )
                : isInlineCode
                    ? Text.rich(
                        _getStyledText(chat.message, colorScheme),
                        style: const TextStyle(fontSize: 16),
                      )
                    : Text(
                        chat.message,
                        style: TextStyle(
                          color: isMe
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface,
                          fontSize: 16,
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  String? _getHighlightLanguage(String? lang) {
    switch (lang) {
      case 'dart':
        return 'dart';
      case 'js':
      case 'javascript':
        return 'javascript';
      case 'py':
      case 'python':
        return 'python';
      default:
        return null;
    }
  }

  TextSpan _getStyledText(String message, ColorScheme colorScheme) {
    final regex = RegExp(r'`(.*?)`');
    final spans = <TextSpan>[];
    int lastMatchEnd = 0;

    for (final match in regex.allMatches(message)) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: message.substring(lastMatchEnd, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: TextStyle(
          fontFamily: 'monospace',
          backgroundColor: colorScheme.surfaceContainerHighest,
          color: colorScheme.onSurfaceVariant,
        ),
      ));
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < message.length) {
      spans.add(TextSpan(text: message.substring(lastMatchEnd)));
    }

    return TextSpan(children: spans);
  }

  Widget _buildMessageInput(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Message',
                hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.send_rounded, color: colorScheme.onPrimary),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 60,
            color: Colors.grey[500],
          ),
          const SizedBox(height: 20),
          Text(
            'No messages yet',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Say hello to start a conversation!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    try {
      final text = _messageController.text.trim();
      if (text.isEmpty) return;
      print("Sending message: $reply");
      final newChat = Chat(
        sender: "alexjohnson",
        receiver: widget.contactName,
        message: text,
        time: DateTime.now(),
        messageId: "${DateTime.now().millisecondsSinceEpoch}",
        isSent: true,
        repliedMessage: reply,
      );

      WsController.sendMessage(newChat);
      _messageController.clear();
      ref.read(chatProvider.notifier).addMessage(newChat);
      setState(() {
        reply = null;
        replyMessage = null;
      });
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    }
  }
}
