import 'package:flutter/material.dart';
import '../utils/styles.dart';
import 'create_password_page.dart';
import '../utils/app_colors.dart';

class VerificationCodePage extends StatelessWidget {
  final TextEditingController _codeController = TextEditingController();

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
            Text('Enter Verification Code',
                style: AppStyles.subtitle, textAlign: TextAlign.center),
            SizedBox(height: 20),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Code'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreatePasswordPage()));
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
