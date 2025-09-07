import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../themes/light_theme.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  Future<void> _showPromptInputDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final existingPrompt = prefs.getString('globalPrompt') ?? '';

    final TextEditingController controller = TextEditingController(text: existingPrompt);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('设置提示词'),
            content: TextField(
              controller: controller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: '输入提示词...',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('取消'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final prompt = controller.text.trim();
                  if (prompt.isNotEmpty) {
                    await prefs.setString('globalPrompt', prompt);
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
                child: const Text('保存'),
              ),
            ],
          );
        }
        );
  }









  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.primary, size: 20,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // 设置
            ListTile(
              leading: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
              title: const Text('设置提示词'),
              subtitle: const Text("点击后输入提示词，可在对话中自动使用"),
              onTap: () => _showPromptInputDialog(context),
            ),
            Divider(
              color: Theme.of(context).colorScheme.surface,
              height: 1,
              indent: 16,
              endIndent: 16,
            ),
          ],
        ),
      )
    );
  }
}