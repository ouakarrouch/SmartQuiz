import 'package:flutter/material.dart';
import '../utils/styles.dart';
import 'login_page.dart';

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 100),
          SizedBox(height: 30),
          Text('Password Changed!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Text('Your password has been changed successfully.',
              textAlign: TextAlign.center),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text('BACK TO LOGIN'),
            style: AppStyles.secondaryButtonStyle,
          ),
        ],
      ),
    );
  }
}
