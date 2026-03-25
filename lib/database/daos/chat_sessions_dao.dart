import 'package:drift/drift.dart';

import 'package:ai_assitant/database/app_database.dart';

import '../tables/chat_sessions.dart';
import '../tables/chat_messages.dart';

part 'chat_sessions_dao.g.dart';

@DriftAccessor(tables: [ChatSessions, ChatMessages])
class ChatSessionsDao extends DatabaseAccessor<AppDatabase> with _$ChatSessionsDaoMixin {
  ChatSessionsDao(AppDatabase db) : super(db);

  // 添加一个聊天会话
  Future<int> insertChatSession(ChatSessionsCompanion session) {
    return into(chatSessions).insert(session, mode: InsertMode.insertOrReplace);
  }

  //删除一个聊天会话及其消息
  Future<void> deleteChatSession(int sessionId) async {
    // 删除会话
    await (delete(chatSessions)
      ..where((tbl) => tbl.id.equals(sessionId))).go();
    // 删除相关消息
    await (delete(chatMessages)
      ..where((msg) => msg.sessionId.equals(sessionId))).go();
  }
  // 获取用户的所有聊天会话
  Future<List<ChatSession>> getSessionsByUser(int userId) {
    return (select(chatSessions)
      ..where((tbl) => tbl.userId.equals(userId))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .get();
  }
  // 更新聊天会话
  Future<bool> updateChatSession(Insertable<ChatSession> session) =>
      update(chatSessions).replace(session);

  // 根据会话 ID 获取聊天会话
  Future<ChatSession> getSessionById(int sessionId) {
    return (select(chatSessions)
      ..where((tbl) => tbl.id.equals(sessionId)))
        .getSingle();
  }

  // 更新聊天会话名称
  Future<bool> updateSessionName(int sessionId, String newName) async {
    final old = await getSessionById(sessionId);
    final updated = ChatSession(
      id: old.id,
      userId: old.userId,
      sessionName: newName,
      createdAt: old.createdAt,
      updatedAt: DateTime.now(),
    );
    return update(chatSessions).replace(updated);
  }
}