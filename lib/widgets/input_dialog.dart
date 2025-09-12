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
                  final input = controller.text.trim();
                  if (input.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('输入内容不能为空'),
                        duration: Duration(milliseconds: 200),
                      ),
                    );
                    return;
                  }

                  try {
                    if (sharedPreferencesKey == 'maxMemory') {
                      // 转整数保存
                      final value = int.tryParse(input);
                      if (value == null || value <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('请输入有效的正整数'),
                            duration: Duration(milliseconds: 200),
                          ),
                        );
                        return;
                      }
                      await prefs.setInt(sharedPreferencesKey, value);
                    } else {
                      // 保存字符串
                      await prefs.setString(sharedPreferencesKey, input);
                    }

                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('已成功设置'),
                        duration: Duration(milliseconds: 200),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('保存失败: $e'),
                        duration: const Duration(milliseconds: 200),
                      ),
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