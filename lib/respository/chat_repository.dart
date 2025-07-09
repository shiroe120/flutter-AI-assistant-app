import 'package:drift/drift.dart';

import '../database/app_database.dart';

abstract class ChatRepository {
  Future<List<ChatSession>> getSessionsByUser(int userId);
  Future<List<ChatMessage>> getMessagesBySession(int sessionId);
  Future<int> insertChatSession(ChatSessionsCompanion session);
  Future<int> insertMessage(ChatMessagesCompanion message);
  Future<void> deleteChatSession(int sessionId);
  Future<void> updateMessageContent(int messageId, String newContent);
  Future<void> updateSessionName(int sessionId, String newName);
  Future<ChatSession> getSessionById(int sessionId);
}