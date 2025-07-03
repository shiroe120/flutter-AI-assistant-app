import 'package:ai_assitant/database/app_database.dart';
import 'package:ai_assitant/pages/home_page.dart';
import 'package:ai_assitant/pages/login_page.dart';
import 'package:ai_assitant/pages/register_page.dart';
import 'package:ai_assitant/respository/local_user_repository.dart';
import 'package:ai_assitant/respository/repository.dart';
import 'package:ai_assitant/themes/dark_theme.dart';
import 'package:flutter/material.dart';
import 'themes/light_theme.dart';
import 'package:provider/provider.dart';
import 'package:ai_assitant/pages/entry_page.dart';

void main() {
  final db = AppDatabase();
  // Ensure the database is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  final userRepository = LocalUserRepository(db);

  runApp(
    Provider<UserRepository>.value(
      value: userRepository,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget{
  MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const EntryPage(),
      theme: lightTheme,
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }


}