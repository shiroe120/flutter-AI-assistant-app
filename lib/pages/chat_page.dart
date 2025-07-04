import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../msg_manager.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<MessagesManager>();
    final messages = manager.messages;

    if (manager.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        return ListTile(
          title: Text(msg.message),
          subtitle: Text(msg.role == 'user' ? '你' : 'AI'),
        );
      },
    );
  }
}
