import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'tables/users.dart';
import 'tables/chat_messages.dart';
import 'tables/chat_sessions.dart';
import 'daos/users_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Users,ChatMessages,ChatSessions], daos: [UsersDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app.db'));

    if (await file.exists()) {
      await file.delete(); // 删除旧数据库（⚠️ 会清空所有数据）
    }

    return NativeDatabase(file);
  });
}

