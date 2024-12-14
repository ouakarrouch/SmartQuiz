import 'package:flutter/material.dart';
import '../utils/styles.dart';
import 'success_page.dart';
import '../utils/app_colors.dart';

class CreatePasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Reset Password'), backgroundColor: Colors.transparent),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Create your new password to login',
                style: AppStyles.subtitle, textAlign: TextAlign.center),
            SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm Password'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SuccessPage()));
              },
              child: Text('SUBMIT'),
              style: AppStyles.secondaryButtonStyle,
            ),
          ],
        ),
      ),
    );
  }
}
