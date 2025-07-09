import 'package:drift/drift.dart';
import 'package:ai_assitant/database/tables/chat_messages.dart';
import 'package:ai_assitant/database/app_database.dart';

part 'chat_messages_dao.g.dart';

@DriftAccessor(tables: [ChatMessages])
class ChatMessagesDao extends DatabaseAccessor<AppDatabase> with _$ChatMessagesDaoMixin {
  ChatMessagesDao(AppDatabase db) : super(db);

  //增加一则消息
  Future<int> insertMessage(Insertable<ChatMessage> message) {
    return into(chatMessages).insert(message);
  }

  //获取某个会话的所有消息
  Future<List<ChatMessage>> getMessagesBySession(int sessionId) {
    return (select(chatMessages)
      ..where((msg) => msg.sessionId.equals(sessionId))
      ..orderBy([(msg) => OrderingTerm.asc(msg.timestamp)]))
        .get();
  }

  // 更新指定 id 的消息内容
  Future<void> updateMessageContent(int messageId, String newContent) async {
    await (update(chatMessages)..where((msg) => msg.id.equals(messageId)))
        .write(ChatMessagesCompanion(message: Value(newContent)));
  }

}


