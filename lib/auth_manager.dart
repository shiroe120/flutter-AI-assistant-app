import 'package:ai_assitant/respository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  final UserRepository repo;

  AuthManager(this.repo);

  Future<String?> login(String email, String password) async {
    return await repo.login(email, password); // null 表示登录成功
  }

  Future<String?> register(String email, String password, String confirm) async {
    return await repo.register(email, password, confirm);
  }

  Future<void> logout() async {
    //清除sharedpref里储存的email字段，loggedin字段改成false
    final pref = await SharedPreferences.getInstance();
    await pref.remove('lastEmail');
    await pref.setBool('loggedIn', false);

  }
}
