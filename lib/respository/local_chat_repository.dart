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
}