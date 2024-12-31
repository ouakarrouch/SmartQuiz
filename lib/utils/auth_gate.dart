import 'package:flutter/material.dart';
import 'package:quiz/screens/home_page.dart';
import 'package:quiz/screens/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      // Listen to auth state changes
      stream: Supabase.instance.client.auth.onAuthStateChange,
      
      // Build appropriate page based on auth state
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Check if there is a valid session
        final session = snapshot.data?.session;

        if (session != null) {
          return HomePage(); // Navigate to HomePage if session exists
        } else {
          return LoginPage(); // Navigate to LoginPage if no session exists
        }
      },
    );
  }
}
