// lib/widgets/ai_message.dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AiMessage extends StatelessWidget {
  final String message;

  const AiMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 2, right: 2, top: 8, bottom: 8),
      constraints: const BoxConstraints(maxWidth: 280),
      child: MarkdownBody(
        data: message,
        selectable: true,
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
          p: const TextStyle(fontSize: 16, color: Colors.black87),
          h1: TextStyle(color: Colors.blue, fontSize: 24),
          blockquote: const TextStyle(color: Colors.blueGrey),
          code: const TextStyle(fontFamily: 'Courier', fontSize: 14),
        ),
      ),
    );
  }
}
