import 'package:ai_assitant/viewModel/msg_manager.dart';
import 'package:ai_assitant/utils/ai_service.dart';
import 'package:ai_assitant/viewModel/session_manager.dart';

import '../database/app_database.dart';

class MessageSender {
  final MessagesManager msgManager;
  final SessionManager sessionManager ;
  final AIService aiService = AIService();

  MessageSender({
    required this.msgManager,
    required this.sessionManager,
  });





  Future<void> sendWithMemory(
      List<ChatMessage> history,
      String userMessage,
      String imagePath,
      MessagesManager msgManager,
      SessionManager sessionManager,
      ) async {
    if (userMessage.trim().isEmpty) return;

    // 插入用户消息
    await msgManager.insertMessage(userMessage, 'user', imagePath: imagePath);

    try {
      // 插入一条空的 AI 消息，并获得 ID
      final messageId = await msgManager.insertMessage('', 'ai');
      if (messageId == -1) return;

      String reply = '';

      // ⭐ 用带记忆的流式方法获取 AI 回复
      await for (final chunk
      in aiService.sendMessageStreamWithMemory(history, userMessage, imagePath)) {
        reply += chunk;
        await msgManager.updateMessageContent(messageId, reply);
      }

      // 判断是否为新会话（消息列表中只有这一条用户消息 + 空 AI 消息）
      final messages = msgManager.messages;
      final isNewSession = messages
          .where((m) => m.role == 'user')
          .length == 1 &&
          messages
              .where((m) => m.role == 'ai')
              .length == 1;

      if (isNewSession && msgManager.sessionId != null) {
        // 调用 AI 生成会话名称
        final promptForName =
            "请根据刚才的对话内容生成一个简短、有意义的会话名称，不能超过10个字，仅返回名称文本，不要任何说明。内容：$reply";

        try {
          final sessionName = await aiService.sendMessageOnce(promptForName);

          if (sessionName.trim().isNotEmpty) {
            // 使用 sessionManager 修改会话名称
            await sessionManager.renameSession(msgManager.sessionId!, sessionName.trim());
          }
        } catch (e) {
          print("自动生成会话名称失败: $e");
        }
      }
    } catch (e) {
      await msgManager.insertMessage('AI 回复失败: $e', 'ai');
    }
  }

}
