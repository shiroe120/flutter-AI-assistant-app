import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../msg_manager.dart';
import '../utils/ai_service.dart';
import '../utils/msg_sender.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final Function send;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.send,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.grey.shade100,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: '请输入消息...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () async {
              await send();
            }
          )

        ],
      ),
    );
  }
}
