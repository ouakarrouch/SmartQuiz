import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart'; // Page d'accueil après connexion réussie
import 'reset_password_page.dart'; // Page pour réinitialiser le mot de passe

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4A4FA8), // Fond violet
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bouton Retour
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  'Back',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(height: 10),

              // Contenu centré
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),

                      // Titre "Log In"
                      Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      SizedBox(height: 10),

                      // Image au-dessus des champs
                      Image.asset(
                        'assets/login_image.png', // Assurez-vous que l'image est dans les assets
                        height: 150,
                      ),

                      SizedBox(height: 20),

                      // Champs Email
                      _buildTextField(_emailController, 'Email', false),

                      // Champs Mot de passe
                      _buildTextField(_passwordController, 'Mot de passe', true),

                      SizedBox(height: 10),

                      // Texte "Mot de passe oublié ?"
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ResetPasswordPage()),
                            );
                          },
                          child: Text(
                            'Vous avez oublié le Mot de Passe?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10),

                      // Bouton Log In
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD9B845), // Couleur jaune
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          String storedEmail = prefs.getString('email') ?? '';
                          String storedPassword = prefs.getString('password') ?? '';

                          if (_emailController.text == storedEmail &&
                              _passwordController.text == storedPassword) {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => HomePage()));
                          } else {
                            setState(() {
                              _errorMessage = 'Email ou mot de passe incorrect';
                            });
                          }
                        },
                        child: Text(
                          'Log In',
                          style: TextStyle(
                              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),

                      // Message d'erreur
                      if (_errorMessage != null) ...[
                        SizedBox(height: 10),
                        Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
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
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          suffixIcon: isPassword ? Icon(Icons.lock_outline, color: Colors.grey) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
