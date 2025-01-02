import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

// Importation des pages
import 'screens/welcome_page.dart';
import 'screens/login_page.dart' as login;
import 'screens/signup_page.dart';
import 'screens/success_page.dart';
import 'screens/settings_page.dart';
import 'screens/security.dart';
import 'screens/logout.dart';
import 'screens/home_page.dart' as home; // Assurez-vous que ce fichier contient une classe `HomePage`
import 'screens/Editprofilepage.dart';
import 'screens/profilepage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Supabase
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
        //'/verify-code': (context) => VerificationPage(), // Page de vérification du code
        //'/create-password': (context) => CreatePasswordPage(), // Page de création du mot de passe
        '/success': (context) => const SuccessPage(),
        '/home': (context) => home.HomePage(),
        '/editProfile': (context) => EditProfilePage(),
        '/settings': (context) => SettingsPage(),
        '/profile': (context) => ProfilePage(),
        '/security': (context) => SecurityPage(),
        '/logout': (context) => LogoutPage(),
      },
    );
  }
}