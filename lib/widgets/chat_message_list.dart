import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../msg_manager.dart';
import '../widgets/user_bubble.dart';
import '../widgets/ai_message.dart';

class ChatMessageList extends StatelessWidget {
  const ChatMessageList({super.key});

  @override
  Widget build(BuildContext context) {
    final handler = context.watch<MessagesManager>();
    final messages = handler.messages;

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final isUser = msg.role == 'user';

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
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
