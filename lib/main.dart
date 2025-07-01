import 'package:ai_assitant/pages/home_page.dart';
import 'package:ai_assitant/pages/login_page.dart';
import 'package:ai_assitant/pages/register_page.dart';
import 'package:ai_assitant/themes/dark_theme.dart';
import 'package:flutter/material.dart';
import 'themes/light_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      theme: lightTheme,
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }


}