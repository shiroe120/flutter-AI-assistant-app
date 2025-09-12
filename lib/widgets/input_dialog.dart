import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart%20';
import 'package:shared_preferences/shared_preferences.dart';

import '../themes/light_theme.dart';

class InputDialog extends StatelessWidget {
  final TextEditingController controller;
  final SharedPreferences prefs;
  final String hintText;
  final String title;
  final String sharedPreferencesKey;

  const InputDialog({
    Key? key,
    required this.controller,
    required this.prefs,
    required this.hintText,
    required this.title,
    required this.sharedPreferencesKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text(title),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      content: TextField(
        controller: controller,
        maxLines: 5,
        decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: underSurface,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1, // 聚焦时稍微加粗
            ),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
        ),
      ),

      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('取消'),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final prompt = controller.text.trim();
                  if (prompt.isNotEmpty) {
                    await prefs.setString(sharedPreferencesKey, prompt);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('提示词已设置')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('提示词不能为空')),
                    );
                  }
                },
                child: const Text('保存', style: TextStyle(color: Colors.white),
              ),
            ),
            )
          ],
        ),
      ],
    );
  }
}