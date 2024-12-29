import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Importation des pages
import 'screens/welcome_page.dart';
import 'screens/login_page.dart' as login;
import 'screens/create_password_page.dart';
import 'screens/signup_page.dart';
import 'screens/verification_code_page.dart';
import 'screens/success_page.dart';
import 'screens/profile_page.dart';
import 'screens/settings_page.dart';
import 'screens/add_account.dart';
import 'screens/edit_profile.dart';
import 'screens/my_quizzes.dart';
import 'screens/security.dart';
import 'screens/logout.dart';
import 'screens/home_page.dart'
    as home; // Assurez-vous que ce fichier contient une classe `HomePage`
// import 'screens/leaderboard_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://iegxqdkoksrodyagftrs.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImllZ3hxZGtva3Nyb2R5YWdmdHJzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUwNTI3MzIsImV4cCI6MjA1MDYyODczMn0.Qj5djsw0zg84pIzw9T8nwfaeA_7bOHnhzkZ-rkh8Jd0',
  );

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
        '/login': (context) => login.LoginPage(),
        //'/reset-password': (context) => ResetPasswordPage(),
        '/verify-code': (context) => VerificationCodePage(),
        '/create-password': (context) => CreatePasswordPage(),
        '/success': (context) => SuccessPage(),
        '/home': (context) =>
            home.HomePage(), // Assurez-vous que cette classe est bien définie
        '/profile': (context) => ProfilePage(),
        '/settings': (context) => SettingsPage(),
        '/editProfile': (context) => EditProfilePage(),
        '/security': (context) => SecurityPage(),
        '/addAccount': (context) => AddAccountPage(),
        '/myQuizzes': (context) => MyQuizzesPage(),
        '/logout': (context) => LogoutPage(),
        // '/leaderboard': (context) => LeaderboardPage(),
      },
    );
  }
}
