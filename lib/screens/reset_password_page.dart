import 'package:flutter/material.dart';
import 'package:quiz/utils/auth_service.dart'; // Assurez-vous d'importer votre service d'authentification

class UserResetPasswordPage extends StatefulWidget {
  const UserResetPasswordPage({super.key});

  @override
  _UserResetPasswordPageState createState() => _UserResetPasswordPageState();
}

class _UserResetPasswordPageState extends State<UserResetPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;  // Nouvelle variable pour le message de succès
  final AuthService _authService = AuthService();

  // Fonction pour valider l'email
  bool _isEmailValid(String email) {
    RegExp emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(email);
  }

  Future<void> _resetPassword() async {
    setState(() {
      _errorMessage = null; // Réinitialise les erreurs
      _successMessage = null; // Réinitialise les messages de succès
    });

    String email = emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez entrer un email';
      });
    } else if (!_isEmailValid(email)) {
      setState(() {
        _errorMessage = 'Veuillez entrer un email valide';
      });
    } else {
      setState(() {
        _isLoading = true; // Start loading
      });

      try {
        // Appel à AuthService pour envoyer un email de réinitialisation
        await _authService.sendPasswordResetEmail(email);

        // Affichage d'un message de succès
        setState(() {
          _successMessage = 'Un email de réinitialisation a été envoyé.';
        });
      } catch (e) {
        setState(() {
          _errorMessage =
              'Une erreur est survenue. Veuillez réessayer plus tard.';
        });
      } finally {
        setState(() {
          _isLoading = false; // Stop loading
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réinitialiser le mot de passe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Entrez votre e-mail pour réinitialiser votre mot de passe',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: Colors.white,
                errorText: _errorMessage,
              ),
            ),
            const SizedBox(height: 20),
            if (_successMessage != null) 
              Text(
                _successMessage!, 
                style: TextStyle(color: Colors.green, fontSize: 16),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _resetPassword,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Envoyer le lien de réinitialisation"),
            ),
          ],
        ),
      ),
    );
  }
}
