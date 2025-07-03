import 'package:ai_assitant/respository/repository.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:drift/drift.dart';

import '../database/app_database.dart';

class LocalUserRepository implements UserRepository {
  final AppDatabase db;

  LocalUserRepository(this.db);

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  @override
  Future<String?> login(String email, String password) async {
    final user = await db.usersDao.getUserByEmail(email);
    if (user == null) return "User not found";

    final hashedInput = _hashPassword(password);
    if (user.password == hashedInput) {
      return null;
    }
    return "Invalid email or password";
  }

  @override
  Future<String?> register(String email, String password, String confirmPassword) async {
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }

    final existing = await db.usersDao.getUserByEmail(email);
    if (existing != null) {
      return 'Email already registered';
    }

    final hashed = _hashPassword(password);
    final userCompanion = UsersCompanion(
      email: Value(email),
      password: Value(hashed),
    );
    await db.usersDao.insertUser(userCompanion);

    return null; // null 表示注册成功
  }
}
