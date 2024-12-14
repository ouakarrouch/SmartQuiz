import 'package:flutter/material.dart';
import '../utils/styles.dart';
import '../utils/app_colors.dart';
import 'signup_page.dart';
import 'login_page.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('SMART QUIZ', style: AppStyles.title)),
          SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUpPage()));
            },
            child: Text('Sign Up'),
            style: AppStyles.primaryButtonStyle,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text('Log In'),
            style: AppStyles.primaryButtonStyle,
          ),
        ],
      ),
    );
  }
}
