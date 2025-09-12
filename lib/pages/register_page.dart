import 'package:ai_assitant/viewModel/auth_manager.dart';
import 'package:ai_assitant/themes/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/app_database.dart';
import '../respository/local_user_repository.dart';
import '../respository/user_repository.dart';
import '../themes/light_theme.dart';
import 'package:ai_assitant/utils/custom_toast.dart';
// register page like the login page but with a register button

class RegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        automaticallyImplyLeading: false,
        titleSpacing: 36,
        title: Text(
          "注册",

          style: TextStyle(
            fontSize: UIConstants.titleFontSize,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),

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
                    Icons.supervised_user_circle,
                    size: 80,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  SizedBox(height: 20),

                  //textField for account
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.onPrimary,
                      labelText: "电子邮件",
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
                      labelText: "密码",
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
                  SizedBox(height: 8),

                  //textField for confirm password
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.onPrimary,
                      labelStyle: TextStyle(color: underSurface),
                      labelText: "重复密码",
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

                  SizedBox(height: 60),

                  //buttons for register
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
                      final userRepository = Provider.of<UserRepository>(context, listen: false);
                      final authManager = AuthManager(userRepository);
                      // Handle register logic here
                      String email = emailController.text;
                      String password = passwordController.text;
                      String confirmPassword = confirmPasswordController.text;

                      if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                        CustomToast.show(context, "请填写所有字段");
                        return;
                      }
                      final result = await authManager.register(email, password, confirmPassword);
                      if (result != null) {
                        CustomToast.show(context, result);
                        return;
                      } else {
                        CustomToast.show(context, "成功注册");
                        Navigator.pop(context); // Go back to login page
                      }
                    },
                    child: Text(
                      "注册",
                      style: TextStyle(
                          fontSize: 16),),
                  ),
                  SizedBox(height: 16),

                  //button for back to login
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size.fromHeight(UIConstants.buttonHeight),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: Theme.of(context).colorScheme.onPrimary,
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "返回登录",
                        style: TextStyle(
                            fontSize: 16),),
                    ),
                  ),
                  SizedBox(height: 60),

                ],
              ),
            ),
          )
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}