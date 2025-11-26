import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../services/api_service.dart';

class MenstruationAIChatScreen extends StatefulWidget {
  final String userId;

  const MenstruationAIChatScreen({super.key, required this.userId});

  @override
  State<MenstruationAIChatScreen> createState() =>
      _MenstruationAIChatScreenState();
}

class _MenstruationAIChatScreenState extends State<MenstruationAIChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add({
        'role': 'ai',
        'content':
            'Hello! 👋 I\'m your menstruation health assistant. I can help you with:\n\n'
            '• Understanding your cycle\n'
            '• Managing symptoms\n'
            '• Answering period-related questions\n'
            '• Providing health tips\n\n'
            'What would you like to know?',
        'timestamp': DateTime.now(),
      });
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Add user message
    setState(() {
      _messages.add({
        'role': 'user',
        'content': text,
        'timestamp': DateTime.now(),
      });
      _isLoading = true;
    });

    _messageController.clear();

    try {
      // Call actual Gemini API through backend
      final apiService = ApiService();

      // Prepare history for context
      final history = _messages.map((msg) {
        return {'role': msg['role'], 'content': msg['content']};
      }).toList();

      final response = await apiService.sendMenstruationChatMessage(
        userId: widget.userId,
        message: text,
        history: history,
      );

      if (mounted) {
        setState(() {
          _messages.add({
            'role': 'ai',
            'content':
                response ??
                'Sorry, I couldn\'t process your request. Please try again.',
            'timestamp': DateTime.now(),
          });
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error sending message: $e');
      if (mounted) {
        setState(() {
          _messages.add({
            'role': 'ai',
            'content':
                'Sorry, I\'m having trouble connecting. Please check your internet connection and try again.',
            'timestamp': DateTime.now(),
          });
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text('Talk to AI'),
        backgroundColor: const Color(0xFFBA68C8),
      ),
      body: Column(
        children: [
          // Disclaimer
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFFFFF3CD),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This AI provides general information only. Always consult your healthcare provider for medical advice.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['role'] == 'user';

                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isUser ? const Color(0xFFBA68C8) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: isUser
                        ? Text(
                            message['content'],
                            style: const TextStyle(color: Colors.white),
                          )
                        : MarkdownBody(
                            data: message['content'],
                            styleSheet: MarkdownStyleSheet(
                              p: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                              strong: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              listBullet: const TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                          ),
                  ),
                );
              },
            ),
          ),

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),

          // Input
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Ask about your cycle...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                  color: const Color(0xFFBA68C8),
                  iconSize: 28,
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
