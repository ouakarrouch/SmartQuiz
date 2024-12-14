import 'package:flutter/material.dart';
import '../utils/styles.dart';
import 'verification_code_page.dart';
import '../utils/app_colors.dart';

class ResetPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar:
          AppBar(title: Text('Reset Password'), backgroundColor: Colors.transparent),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Entrez votre E-mail pour changer votre mot de passe',
                style: AppStyles.subtitle, textAlign: TextAlign.center),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'Email', filled: true),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => VerificationCodePage()));
              },
              child: Text('Send Email'),
              style: AppStyles.primaryButtonStyle,
            ),
          ],
        ),
      ),
    );
  }
}
