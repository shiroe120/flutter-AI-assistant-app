import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModel/msg_manager.dart';
import '../widgets/user_bubble.dart';
import '../widgets/ai_message.dart';

class ChatMessageList extends StatefulWidget {
  const ChatMessageList({super.key});

  @override
  State<ChatMessageList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatMessageList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant ChatMessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scrollToBottom();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final handler = context.watch<MessagesManager>();
    final messages = handler.messages;


    return ListView.builder(
      controller: _scrollController,
      itemCount: messages.length,
      padding: const EdgeInsets.only(bottom: 80), // 留出底部空间给输入框
      itemBuilder: (context, index) {
        final msg = messages[index];
        final isUser = msg.role == 'user';

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: isUser
                ? UserBubble(message: msg.message)
                : AiMessage(message: msg.message),
          ),
        );
      },
    );
  }
}
