// lib/widgets/ai_message.dart
import 'package:flutter/material.dart';

class AiMessage extends StatelessWidget {
  final String message;

  const AiMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      constraints: const BoxConstraints(maxWidth: 280),
      child: Text(
        message,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
