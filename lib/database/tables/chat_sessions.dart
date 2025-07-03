import 'package:drift/drift.dart';

class ChatSessions extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get userId => text()(); // Reference to the user

  TextColumn get sessionName => text().withLength(min: 1, max: 100)();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}