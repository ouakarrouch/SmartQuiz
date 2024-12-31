import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz/utils/auth_service.dart'; // Import du service d'authentification
import 'package:quiz/screens/home_page.dart'; // Assurez-vous que HomePage existe
import 'package:quiz/screens/reset_password_page.dart'; // Page de réinitialisation
import 'package:quiz/screens/welcome_page.dart'; // Import de la WelcomePage

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String? _errorMessage;
  final AuthService _authService = AuthService();

  Future<void> signInWithEmail() async {
    if (!mounted) return; // Ensure the widget is still mounted

    setState(() {
      isLoading = true;
      _errorMessage = null; // Réinitialise le message d'erreur
    });

    try {
      final email = emailController.text.trim();
      final password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        throw Exception("Veuillez remplir tous les champs.");
      }

      // Connexion via AuthService
      final res = await _authService.signInWithEmailPassword(email, password);

      if (res.user != null) {
        final userId = res.user!.id;

        // Sauvegarde de l'utilisateur localement
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', userId);

        // Redirection vers la page d'accueil
        if (mounted) {
          Navigator.pushReplacementNamed(
              context, '/home'); // Assurez-vous que '/home' est défini
        }
      } else {
        throw Exception("Email ou mot de passe incorrect.");
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll("Exception: ", "");
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A4FA8), // Fond violet
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bouton Retour qui redirige vers la WelcomePage
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            WelcomePage()), // Redirection vers WelcomePage
                  );
                },
                child: const Text(
                  'Back',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 10),

              // Contenu centré
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Titre "Log In"
                      const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Image au-dessus des champs
                      Image.asset(
                        'assets/login_image.png', // Assurez-vous que l'image existe
                        height: 150,
                      ),

                      const SizedBox(height: 20),

                      // Champs Email
                      _buildTextField(emailController, 'Email', false),

                      // Champs Mot de passe
                      _buildTextField(passwordController, 'Mot de passe', true),

                      const SizedBox(height: 10),

                      // Texte "Mot de passe oublié ?"
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const UserResetPasswordPage()),
                            );
                          },
                          child: const Text(
                            'Vous avez oublié le Mot de Passe?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Bouton Log In
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFD9B845), // Couleur jaune
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: isLoading ? null : signInWithEmail,
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Log In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),

                      // Message d'erreur
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pour les champs de texte
  Widget _buildTextField(
      TextEditingController controller, String hintText, bool isPassword) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: isPassword
              ? const Icon(Icons.lock_outline, color: Colors.grey)
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
