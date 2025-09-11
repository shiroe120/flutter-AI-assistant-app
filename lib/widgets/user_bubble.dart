import 'dart:io';

import 'package:flutter/material.dart';

class UserBubble extends StatelessWidget {
  final String message;
  //可能存在的图片路径
  final String? imagePath;

  const UserBubble({super.key, required this.message, this.imagePath = ''});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final textColor = Theme.of(context).colorScheme.onPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      constraints: const BoxConstraints(maxWidth: 280),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // 如果有图片路径，显示图片
          if (imagePath != null && imagePath!.isNotEmpty)
GestureDetector(
  onTap: () {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(imagePath!),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  },
  child: Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(
        File(imagePath!),
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      ),
    ),
  ),
),
          Text(
            message,
            style: TextStyle(color: textColor, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
