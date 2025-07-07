import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'daos/chat_messages_dao.dart';
import 'daos/chat_sessions_dao.dart';
import 'tables/users.dart';
import 'tables/chat_messages.dart';
import 'tables/chat_sessions.dart';
import 'daos/users_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Users,ChatMessages,ChatSessions], daos: [UsersDao, ChatMessagesDao, ChatSessionsDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {

  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app.db'));
    return NativeDatabase(file);
  });
}

