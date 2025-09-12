import 'package:ai_assitant/widgets/chat_input_bar.dart';
import 'package:ai_assitant/widgets/chat_message_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../viewModel/msg_manager.dart';
import '../viewModel/session_manager.dart';
import '../utils/ai_service.dart';
import '../utils/msg_sender.dart';

// 显示聊天消息和发送聊天消息
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // 暂存的选取的图片的路径
  String imagePath = '';
  final TextEditingController _textController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<MessagesManager>(
      builder: (context, messagesManager, child) {
        return Column(
          children: [
            Expanded(
              child: messagesManager.messages.isEmpty
                  ? Center(
                child: Text(
                  "问任何事。",
                  style: TextStyle(
                    fontSize: 36,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )

              // 消息列表
                  : ChatMessageList(),
            ),

            //消息发送框
            ChatInputBar(
              controller: _textController,
              // 传入图片选取函数
              onPicked: (String path) {
                setState(() {
                  imagePath = path;
                });
              },
              send: () async {
                final userMessage = _textController.text.trim();
                if (userMessage.isEmpty) return;
                // 清空输入框
                _textController.clear();

                //获取历史消息列表
                final history = messagesManager.messages;
                //创建消息发送器
                MessageSender _messageSender = MessageSender(
                  sessionManager: Provider.of<SessionManager>(context, listen: false),
                  msgManager: messagesManager,
                );
                // 发送消息
                await _messageSender.sendWithMemory(history, userMessage, imagePath, messagesManager,
                    Provider.of<SessionManager>(context, listen: false));

              },
            ),
          ],
        );
      }
      );
  }
}
