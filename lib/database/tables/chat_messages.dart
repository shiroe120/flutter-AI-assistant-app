import 'package:drift/drift.dart';

class ChatMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer()(); // Foreign key to ChatSessions
  TextColumn get role => text()();//user or ai
  TextColumn get message => text().withLength(min: 1, max: 500)();
  DateTimeColumn get timestamp => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}