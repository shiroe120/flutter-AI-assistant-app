import 'package:drift/drift.dart';

import '../database/app_database.dart';

abstract class ChatRepository {
/// 根据用户ID获取所有聊天会话
Future<List<ChatSession>> getSessionsByUser(int userId);

/// 根据会话ID获取所有消息
Future<List<ChatMessage>> getMessagesBySession(int sessionId);

/// 插入新的聊天会话，返回新会话的ID
Future<int> insertChatSession(ChatSessionsCompanion session);

/// 插入新的消息，返回新消息的ID
Future<int> insertMessage(ChatMessagesCompanion message);

/// 删除一则消息，返回受影响的行数
Future<int> deleteMessage(int messageId);

/// 删除一个聊天会话及其相关消息
Future<void> deleteChatSession(int sessionId);

/// 更新消息内容
Future<void> updateMessageContent(int messageId, String newContent);

/// 更新会话名称
Future<void> updateSessionName(int sessionId, String newName);

/// 根据会话ID获取会话详情
Future<ChatSession> getSessionById(int sessionId);
}