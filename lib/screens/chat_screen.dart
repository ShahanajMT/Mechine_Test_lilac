

import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class ChatScreen extends StatefulWidget {
  final String chatName;
  final String chatImage;

  const ChatScreen({super.key, required this.chatName, required this.chatImage});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final Random _random = Random();
  Timer? _responseTimer;

  // Predefined responses for the random chat partner
  final List<String> _randomResponses = [
    "Hello there!",
    "How are you doing?",
    "What are you up to?",
    "Nice to chat with you!",
    "Tell me more about yourself",
    "That's interesting!",
    "I've never thought about it that way",
    "What do you do for fun?",
    "Any plans for the weekend?",
    "I'm just browsing around",
    "That sounds exciting!",
    "What's your favorite hobby?",
    "I'm learning new things too",
    "The weather is nice today",
    "Have you seen any good movies lately?",
  ];

  @override
  void initState() {
    super.initState();
    // Initial greeting from the chat partner
    _addReceivedMessage("Hello! I'm your random chat partner");
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _responseTimer?.cancel();
    super.dispose();
  }

  void _addSentMessage(String text) {
    setState(() {
      _messages.insert(0, Message(text: text, isSentByMe: true));
      _scrollToBottom();
    });
    _scheduleRandomResponse();
  }

  void _addReceivedMessage(String text) {
    setState(() {
      _messages.insert(0, Message(text: text, isSentByMe: false));
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _scheduleRandomResponse() {
    // Cancel any pending responses
    _responseTimer?.cancel();
    
    // Schedule a new response after 1-5 seconds
    _responseTimer = Timer(
      Duration(seconds: 1 + _random.nextInt(4)),
      () {
        final response = _randomResponses[_random.nextInt(_randomResponses.length)];
        _addReceivedMessage(response);
      },
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      _addSentMessage(text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.chatImage),
              radius: 18,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chatName,
                  style: const TextStyle(fontSize: 16),
                ),
                const Text(
                  'Online',
                  style: TextStyle(fontSize: 12, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () => _showFeatureDialog('Voice Call'),
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () => _showFeatureDialog('Video Call'),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showMoreOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(child: Text('Start a conversation!'))
                : ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return message.isSentByMe
                          ? _buildSentMessage(message.text)
                          : _buildReceivedMessage(message.text);
                    },
                  ),
          ),
          _buildChatInputArea(),
        ],
      ),
    );
  }

  Widget _buildSentMessage(String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.pink,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildReceivedMessage(String message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Text(message),
      ),
    );
  }

  Widget _buildChatInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: const Border(top: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showFeatureDialog('Attachment Options'),
          ),
          IconButton(
            icon: const Icon(Icons.emoji_emotions),
            onPressed: () => _showFeatureDialog('Emoji Picker'),
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (text) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () => _showFeatureDialog('Voice Message'),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
            color: Colors.pink,
          ),
        ],
      ),
    );
  }

  void _showFeatureDialog(String featureName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$featureName Coming Soon!'),
        content: Text('This feature is under development'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Chat Info'),
            onTap: () {
              Navigator.pop(context);
              _showFeatureDialog('Chat Info');
            },
          ),
          ListTile(
            leading: const Icon(Icons.block),
            title: const Text('Block User'),
            onTap: () {
              Navigator.pop(context);
              _showFeatureDialog('Block User');
            },
          ),
          ListTile(
            leading: const Icon(Icons.report),
            title: const Text('Report User'),
            onTap: () {
              Navigator.pop(context);
              _showFeatureDialog('Report User');
            },
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final bool isSentByMe;
  final DateTime timestamp;

  Message({
    required this.text,
    required this.isSentByMe,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}