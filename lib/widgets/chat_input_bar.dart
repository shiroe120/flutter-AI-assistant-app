import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewModel/msg_manager.dart';
import '../themes/light_theme.dart';
import '../utils/ai_service.dart';
import '../utils/msg_sender.dart';


class ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final Future<void> Function() send;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.send,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  bool hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final isNotEmpty = widget.controller.text.trim().isNotEmpty;
    if (hasText != isNotEmpty) {
      setState(() {
        hasText = isNotEmpty;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 20, top: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
        color: Theme.of(context).colorScheme.onPrimary,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              minLines: 1,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                hintText: '请输入消息...',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              ),
            ),
          ),

          IconButton(
            onPressed: () {
              // 麦克风逻辑
            },
            icon: const Icon(Icons.keyboard_voice),
            focusColor: Theme.of(context).colorScheme.onPrimary,
            color: Theme.of(context).colorScheme.primary,
          ),

          IconButton(
            icon: const Icon(Icons.send),
            color: hasText
                ? Theme.of(context).colorScheme.primary
                : Colors.grey, // 根据输入内容变色
            onPressed: hasText
                ? () async {
              await widget.send();
            }
                : null, // 可选禁用点击
          ),
        ],
      ),
    );
  }
}

