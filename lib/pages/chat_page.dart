import 'package:ai_assitant/widgets/chat_input_bar.dart';
import 'package:ai_assitant/widgets/chat_message_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../msg_manager.dart';
import '../session_manager.dart';
import '../utils/ai_service.dart';
import '../utils/msg_sender.dart';

// 显示聊天消息和发送聊天消息
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isInitializing = true;
  final TextEditingController _textController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeSession();

  }
  // 初始化AI服务并获取回复

  // 初始化会话
  Future<void> _initializeSession() async {
    try {
      final sessionManager = Provider.of<SessionManager>(context, listen: false);
      final messagesManager = Provider.of<MessagesManager>(context, listen: false);

      // 创建新会话
      final newSessionId = await sessionManager.createNewSession();

      // 插入默认消息
      await messagesManager.setSessionId(newSessionId);

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
        return Column(
          children: [
            Expanded(
              child: ChatMessageList(
              ),
            ),
            ChatInputBar(
              controller: _textController,
              send: () async {
                final userMessage = _textController.text.trim();
                if (userMessage.isEmpty) return;
                // 清空输入框
                _textController.clear();
                MessageSender _messageSender = MessageSender(
                  msgManager: messagesManager,
                );
                // 发送消息
                await _messageSender.send(userMessage);
                // 滚动到最新消息

              },
            ),
          ],
        );
      }
      );
  }
}
