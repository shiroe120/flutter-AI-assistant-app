import 'package:ai_assitant/database/app_database.dart';

import 'chat_repository.dart';

class LocalChatRepository implements ChatRepository {
  final AppDatabase db;

  LocalChatRepository(this.db);

  @override
  Future<List<ChatSession>> getSessionsByUser(int userId) async {
    return await db.chatSessionsDao.getSessionsByUser(userId);
  }

  @override
  Future<List<ChatMessage>> getMessagesBySession(int sessionId) async {
    return await db.chatMessagesDao.getMessagesBySession(sessionId);
  }

  @override
  Future<int> insertChatSession(ChatSessionsCompanion session) async {
    return db.chatSessionsDao.insertChatSession(session);
  }
  @override
  Future<int> insertMessage(ChatMessagesCompanion message) async {
    return db.chatMessagesDao.insertMessage(message);
  }

  @override
  Future<void> deleteChatSession(int sessionId) async {
    await db.chatSessionsDao.deleteChatSession(sessionId);
  }
  @override
  Future<void> updateMessageContent(int messageId, String newContent) async {
    await db.chatMessagesDao.updateMessageContent(messageId, newContent);
  }

  @override
  Future<bool> updateSessionName(int sessionId, String newName) async {
    final old = await getSessionById(sessionId);
    final updated = ChatSession(
      id: old.id,
      userId: old.userId,
      sessionName: newName,
      createdAt: old.createdAt,
      updatedAt: DateTime.now(),
    );
    return db.chatSessionsDao.updateChatSession(updated);
  }

  @override
  Future<ChatSession> getSessionById(int sessionId) async {
    return await db.chatSessionsDao.getSessionById(sessionId);
  }

}