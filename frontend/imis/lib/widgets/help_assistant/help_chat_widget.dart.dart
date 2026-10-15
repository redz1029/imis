import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/widgets/help_assistant/help_assistant.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final List<String>? steps;

  ChatMessage({required this.text, required this.isUser, this.steps});
}

class HelpChatWidget extends StatefulWidget {
  const HelpChatWidget({super.key});

  @override
  State<HelpChatWidget> createState() => _HelpChatWidgetState();
}

class _HelpChatWidgetState extends State<HelpChatWidget>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  final TextEditingController _inputCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          "Hi! I'm the CPeMS Help Assistant. Ask me how to create a deliverable, SWOT, or other tasks in the system.",
      isUser: false,
    ),
  ];

  void _toggleChat() {
    setState(() => _isOpen = !_isOpen);
  }

  void _sendMessage() {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));

      final results = searchHelpTopics(text);

      if (results.isNotEmpty) {
        final topic = results.first;
        _messages.add(
          ChatMessage(text: topic.question, isUser: false, steps: topic.steps),
        );
      } else {
        _messages.add(
          ChatMessage(
            text:
                "Sorry, I don't have an answer for that yet. Try asking about: create/edit/delete deliverable, SWOT, or deliverable monitoring.",
            isUser: false,
          ),
        );
      }
    });

    _inputCtrl.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: 20,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        alignment: Alignment.bottomRight,
        child: _isOpen ? _buildChatPanel() : _buildBubble(),
      ),
    );
  }

  Widget _buildBubble() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: _toggleChat,
        child: Container(
          padding: const EdgeInsets.only(
            left: 10,
            right: 16,
            top: 8,
            bottom: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: primaryColor,
                    child: const Icon(
                      Icons.support_agent,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  Positioned(
                    right: -1,
                    bottom: -1,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.shade400,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              const Text(
                'Need help?',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatPanel() {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: 330,
        height: 440,
        color: Colors.white,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildMessageList()),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white24,
                child: Icon(Icons.support_agent, color: Colors.white, size: 18),
              ),
              Positioned(
                right: -1,
                bottom: -1,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.shade400,
                    shape: BoxShape.circle,
                    border: Border.all(color: primaryColor, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cemsy',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(color: Colors.white70, fontSize: 10.5),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 18),
            onPressed: _toggleChat,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return Container(
      color: const Color(0xFFF5F6FA),
      child: ListView.builder(
        controller: _scrollCtrl,
        padding: const EdgeInsets.all(10),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final msg = _messages[index];
          return Align(
            alignment:
                msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!msg.isUser) ...[
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: primaryColor,
                    child: const Icon(
                      Icons.support_agent,
                      color: Colors.white,
                      size: 13,
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 220),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: msg.isUser ? primaryColor : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: Radius.circular(msg.isUser ? 12 : 2),
                        bottomRight: Radius.circular(msg.isUser ? 2 : 12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.text,
                          style: TextStyle(
                            fontSize: 12,
                            color: msg.isUser ? Colors.white : Colors.black87,
                            fontWeight:
                                msg.steps != null
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                          ),
                        ),
                        if (msg.steps != null) ...[
                          const SizedBox(height: 6),
                          ...msg.steps!.asMap().entries.map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                '${e.key + 1}. ${e.value}',
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  height: 1.4,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputCtrl,
              style: const TextStyle(fontSize: 12),
              decoration: InputDecoration(
                hintText: 'Type your question here...',
                hintStyle: const TextStyle(fontSize: 12),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 6),
          Material(
            color: primaryColor,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _sendMessage,
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.send, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
