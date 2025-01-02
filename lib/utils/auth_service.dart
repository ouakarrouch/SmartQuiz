import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sign in with email and password
  Future<AuthResponse> signInWithEmailPassword(
      String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign up with email, password, and additional user data
  Future<AuthResponse> signUp(String firstName, String lastName, String email,
      String phone, String password, String confirmPassword) async {
    if (password != confirmPassword) {
      throw Exception("Passwords do not match");
    }

    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
      },
    );
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Get the current user's email
  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      // Call resetPasswordForEmail which returns void
      await _supabase.auth.resetPasswordForEmail(email);
      // Inform the user that the password reset email has been sent
      print('Password reset email sent to $email');
    } catch (e) {
      // Handle any exceptions or errors that occur
      throw Exception('Error occurred while sending password reset email: $e');
    }
  }
}
