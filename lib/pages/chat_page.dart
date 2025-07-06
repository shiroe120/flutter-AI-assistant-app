import 'package:ai_assitant/widgets/chat_message_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../msg_manager.dart';
import '../session_manager.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeSession();
  }

  // 初始化会话
  Future<void> _initializeSession() async {
    try {
      final sessionManager = Provider.of<SessionManager>(context, listen: false);
      final messagesManager = Provider.of<MessagesManager>(context, listen: false);

      // 创建新会话
      final newSessionId = await sessionManager.createNewSession();

      // 插入默认消息
      await messagesManager.setSessionId(newSessionId);
      await messagesManager.insertDefaultMessage();

    } catch (e) {
      // 处理错误，例如显示错误提示
      print("初始化会话失败，哈哈，不报错了: $e");
    } finally {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<MessagesManager>(
      builder: (context, messagesManager, child) {
        // 插入一条默认消息
        if (messagesManager.messages.isEmpty) {
          return Center(
            child: Text(
              '没有消息，请开始对话',
              style: TextStyle(
                color: Theme
                    .of(context)
                    .colorScheme
                    .onSurface,
                fontSize: 18,
              ),
            ),
          );
        }
        return ChatMessageList(
          key: ValueKey('messages-${messagesManager.sessionId}'),
        );
      }
      );
  }
}
