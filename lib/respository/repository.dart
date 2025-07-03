import '../database/app_database.dart';

abstract class UserRepository {
  Future<String?> login(String email, String password);
  Future<String?> register(String email, String password, String confirmPassword);
}
