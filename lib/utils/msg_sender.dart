import 'package:ai_assitant/msg_manager.dart';
import 'package:ai_assitant/utils/ai_service.dart';

class MessageSender {
  final MessagesManager msgManager;
  final AIService aiService = AIService();
  MessageSender({
    required this.msgManager,
  });

  /// 处理一条用户消息：插入、调用 AI、插入 AI 回复
  Future<void> send(String userMessage) async {
    if (userMessage.trim().isEmpty) return;

    // 插入用户消息
    await msgManager.insertMessage(userMessage, 'user');

    try {
      // 获取 AI 回复
      final aiReply = await aiService.sendMessage(userMessage);

      // 插入 AI 回复
      await msgManager.insertMessage(aiReply, 'ai');
    } catch (e) {
      // 插入错误消息
      await msgManager.insertMessage('AI 回复失败: $e', 'ai');
    }
  }
}
