import 'package:flutter/material.dart';
import 'screens/welcome_page.dart';
import 'screens/login_page.dart';
import 'screens/create_password_page.dart';
import 'screens/home_page.dart';
import 'screens/signup_page.dart';  // Make sure this path is correct
import 'screens/reset_password_page.dart';  // Make sure this path is correct
import 'screens/verification_code_page.dart';  // Make sure this path is correct
import 'screens/success_page.dart';  // Make sure this path is correct
import 'screens/profile_page.dart';
import 'screens/settings_page.dart';
import 'screens/add_account.dart';
import 'screens/edit_profile.dart';
import 'screens/my_quizzes.dart';
import 'screens/security.dart';
import 'screens/logout.dart';
import 'screens/LeaderboardPage.dart';

void main() {
  runApp(SmartQuizApp());
}

class SmartQuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Smart Quiz App",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomePage(), // Page d'accueil par défaut
      routes: {
        '/signup': (context) => SignUpPage(),
        '/login': (context) => LoginPage(),
        '/reset-password': (context) => ResetPasswordPage(),
        '/verify-code': (context) => VerificationCodePage(),
        '/create-password': (context) => CreatePasswordPage(),
        '/success': (context) => SuccessPage(),
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(), // Ajoutez cette ligne
          '/settings': (context) => SettingsPage(), // Ajoutez cette ligne
          '/editProfile': (context) => EditProfilePage(),
        '/security': (context) => SecurityPage(),
        '/addAccount': (context) => AddAccountPage(),
        '/myQuizzes': (context) => MyQuizzesPage(),
        '/logout': (context) => LogoutPage(), // Route pour la déconnexion
        '/leaderboard': (context) => LeaderboardPage(),
          
      },
    );
  }
}
