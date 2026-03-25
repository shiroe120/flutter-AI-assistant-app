import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../themes/light_theme.dart';
import '../widgets/input_dialog.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  Future<void> _showPromptInputDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final existingPrompt = prefs.getString('globalPrompt') ?? '';

    final TextEditingController controller = TextEditingController(text: existingPrompt);

    showDialog(
      context: context,
      builder: (context) => InputDialog(
          title:"设置提示词",
          hintText: '输入提示词',
          sharedPreferencesKey: 'globalPrompt',
          controller: controller,
          prefs: prefs),
    );
  }
  // 展示apikey的输入框表单
  Future<void> _showApiKeyInputDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final existingApiKey = prefs.getString('apiKey') ?? '';

    final TextEditingController controller = TextEditingController(text: existingApiKey);

    showDialog(
      context: context,
      builder: (context) => InputDialog(
        title: "设置 API Key",
        hintText: '输入 API Key',
          sharedPreferencesKey: 'apiKey',
          controller: controller, prefs: prefs),
    );
  }
  // 展示modelId的输入框表单
  Future<void> _showModelIdInputDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final existingModelId = prefs.getString('modelId') ?? '';

    final TextEditingController controller = TextEditingController(text: existingModelId);

    showDialog(
      context: context,
      builder: (context) => InputDialog(
          title: "设置 Model ID",
          hintText: '输入 Model ID',
          sharedPreferencesKey: 'modelId',
          controller: controller, prefs: prefs),
    );
  }

  // 展示连续对话数上线的输入框表单
  Future<void> _showMaxMemoryInputDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final existingValue = prefs.getInt('maxMemory') ?? 5; // 默认 5 条

    final TextEditingController controller = TextEditingController(text: existingValue.toString());

    showDialog(
      context: context,
      builder: (context) => InputDialog(
        title: "设置连续对话数上限",
        hintText: '输入最大连续对话数',
        sharedPreferencesKey: 'maxMemory',
        controller: controller,
        prefs: prefs,
      ),
    );
  }

  // 展示百度云SecretKey的输入框表单
  Future<void> _showBaiduSecretKeyInputDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final existingSecretKey = prefs.getString('baiduSecretKey') ?? '';

    final TextEditingController controller = TextEditingController(text: existingSecretKey);

    showDialog(
      context: context,
      builder: (context) => InputDialog(
          title: "设置百度云 Secret Key",
          hintText: '输入百度云 Secret Key',
          sharedPreferencesKey: 'baiduSecretKey',
          controller: controller, prefs: prefs),
    );
  }

  // 展示百度云AccessKey的输入框表单
  Future<void> _showBaiduAccessKeyInputDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final existingAccessKey = prefs.getString('baiduAccessKey') ?? '';

    final TextEditingController controller = TextEditingController(text: existingAccessKey);

    showDialog(
      context: context,
      builder: (context) => InputDialog(
          title: "设置百度云 Access Key",
          hintText: '输入百度云 Access Key',
          sharedPreferencesKey: 'baiduAccessKey',
          controller: controller, prefs: prefs),
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
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal:8,vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 设置
            ListTile(
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
            ListTile(
              title: const Text('设置ModelId'),
              subtitle: const Text("默认只支持火山引擎的模型"),
              onTap: () => _showModelIdInputDialog(context),
            ),
            Divider(
              color: Theme.of(context).colorScheme.surface,
              height: 1,
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
              title: const Text('设置apiKey'),
              subtitle: const Text("点击后输入apiKey"),
              onTap: () => _showApiKeyInputDialog(context),
            ),
            Divider(
              color: Theme.of(context).colorScheme.surface,
              height: 1,
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
              title: const Text('设置连续对话数上限'),
              subtitle: const Text("连续对话数过大可能导致延迟"),
              onTap: () => _showMaxMemoryInputDialog(context),
            ),
            Divider(
              color: Theme.of(context).colorScheme.surface,
              height: 1,
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
              title: const Text('设置百度云 Secret Key'),
              subtitle: const Text("用于语音识别"),
              onTap: () => _showBaiduSecretKeyInputDialog(context),
            ),
            Divider(
              color: Theme.of(context).colorScheme.surface,
              height: 1,
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
              title: const Text('设置百度云 Access Key'),
              subtitle: const Text("用于语音识别"),
              onTap: () => _showBaiduAccessKeyInputDialog(context),
            ),
          ],
        ),
      )
    );
  }
}