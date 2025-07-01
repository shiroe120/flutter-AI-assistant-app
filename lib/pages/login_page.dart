import 'package:ai_assitant/themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:ai_assitant/themes/ui_constants.dart';
class LoginPage extends StatelessWidget{
  const LoginPage({super.key});


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
          
                //textField for account
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.onPrimary,
                    labelText: "Email", labelStyle: TextStyle(color: underSurface),
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
                      )
                    )
                  ),
                SizedBox(height: 8),
          
                //textField for password
                TextField(
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
                    minimumSize: Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                        fontSize: 16),),
                ),
                SizedBox(height: 16),
                // Register button to navigate to the register page
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size.fromHeight(48),
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