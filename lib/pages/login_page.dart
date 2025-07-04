import 'package:ai_assitant/themes/light_theme.dart';
import 'package:ai_assitant/utils/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:ai_assitant/themes/ui_constants.dart';
import 'package:ai_assitant/auth_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/app_database.dart';
import '../respository/local_user_repository.dart';
import '../respository/user_repository.dart';


class LoginPage extends StatefulWidget{
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final authManager = AuthManager(LocalUserRepository(AppDatabase()));

  @override
  void initState() {
    super.initState();
    _loadLastEmail();
  }

  void _loadLastEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('lastEmail') ?? '';
    emailController.text = email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
              "LOGIN",
              style: TextStyle(
                fontSize: UIConstants.titleFontSize,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        titleSpacing: 36,

      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: UIConstants.pagePadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //logo or anything else
                Icon(
                  Icons.account_circle,
                  size: 80,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                SizedBox(height: 20),

                //textField for email
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.onPrimary,
                    labelText: "Email",
                    labelStyle: TextStyle(color: underSurface),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: underSurface,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary, // primary
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    errorText: emailController.text.isNotEmpty &&
                            !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(emailController.text)
                        ? "请输入有效的邮箱地址"
                        : null,
                  ),
                  onChanged: (_) {
                    (context as Element).markNeedsBuild();
                  },
                ),
                SizedBox(height: 8),

                //textField for password
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.onPrimary,
                    labelStyle: TextStyle(color: underSurface),
                    labelText: "Password",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: underSurface, // midsurface
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary, // primary
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Welcome message
                Center(
                  child: Text(
                    "Welcome to the AI Assistant App!  ",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                SizedBox(height: 60),

                //buttons for login
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(UIConstants.buttonHeight),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    elevation: 0,
                  ),
                  onPressed: () async {
                    // Handle login logic here

                    final userRepository = Provider.of<UserRepository>(context, listen: false);
                    final authManager = AuthManager(userRepository);

                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();

                    if (email.isEmpty || password.isEmpty) {
                      CustomToast.show( context, "Please fill in all fields");
                      return;
                    }

                    final result = await authManager.login(email, password);
                    if (result != null) {
                      CustomToast.show(context, result);
                      return;
                    }else{
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('loggedIn', true);
                      //查询用户ID
                      final userId = await userRepository.getUserIdByEmail(email);
                      await prefs.setInt('currentUserId', userId!);
                      CustomToast.show(context, "Login successful");
                      Navigator.pushNamed(context, '/home');
                    }
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                        fontSize: 16),),
                ),
                SizedBox(height: 8),
                // Register button to navigate to the register page
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size.fromHeight(UIConstants.buttonHeight),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary
                    ),
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: (){
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text("Register",
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary
                      ),),
                ),
                SizedBox(height: 80),
              ],
            ),
          ),
        )
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}