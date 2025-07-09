// lib/widgets/ai_message.dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AiMessage extends StatelessWidget {
  final String message;

  const AiMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 6, top: 8, bottom: 8),
      constraints: const BoxConstraints(maxWidth: 280),
      child: MarkdownBody(
        data: message,
        selectable: true,
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
          // 段落文本
          p: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Theme.of(context).colorScheme.onSurface,
          ),

          // 一级标题
          h1: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),

          // 二级标题
          h2: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
          ),

          // 引用块
          blockquote: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.blueGrey.shade700,
          ),
          blockquoteDecoration: BoxDecoration(
            color: Colors.blueGrey.shade50,
            border: Border(
              left: BorderSide(
                color: Colors.blueGrey,
                width: 4,
              ),
            ),
          ),

          // 代码（行内）
          code: const TextStyle(
            fontFamily: 'Courier',
            fontSize: 14,
            backgroundColor: Color(0xFFF5F5F5),
          ),

          // 代码块（多行）
          codeblockDecoration: BoxDecoration(
            color: const Color(0xFFf6f8fa),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey.shade300,
            ),
          ),

          // 有序列表
          listBullet: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85),
          ),

          // 表格文本
          tableBody: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          tableHead: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
