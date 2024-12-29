import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Initialize Supabase
    Supabase.initialize(
      url: 'https://iegxqdkoksrodyagftrs.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImllZ3hxZGtva3Nyb2R5YWdmdHJzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUwNTI3MzIsImV4cCI6MjA1MDYyODczMn0.Qj5djsw0zg84pIzw9T8nwfaeA_7bOHnhzkZ-rkh8Jd0',
    );
  }

  Future<void> _signUp() async {
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Créer un utilisateur avec Supabase Auth
        final response = await Supabase.instance.client.auth.signUp(
          email: email,
          password: password,
        );

        if (response.user != null) {
          // Utilisateur inscrit avec succès, maintenant ajoutez des informations supplémentaires
          final user = response.user;

          // Insérer les données de l'utilisateur dans la table 'users'
          final insertResponse = await Supabase.instance.client
              .from('users') // Assurez-vous que le nom de la table est correct
              .insert({
                'id': user!.id,
                'email': email,
                'first_name': firstName,
                'last_name': lastName,
                'phone': _phoneController.text,
              })
              .select()
              .single();

          // Vérifier les erreurs après l'insertion
          // Vérifier si `insertResponse` contient une erreur dans la réponse
          if (insertResponse['error'] != null) {
            _showError(
                'Error while saving user data: ${insertResponse['error']['message']}');
          } else {
            // Gérer l'insertion réussie et rediriger vers la page de connexion
            Navigator.pushReplacementNamed(
                context, '/login'); // Redirection vers la page login
          }
        } else {
          _showError('Failed to sign up. Please try again.');
        }
      } catch (e) {
        _showError('Error: ${e.toString()}');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4A4FA8), // Purple background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text('Back',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
              SizedBox(height: 10),

              // Centered Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),

                      // Sign Up Heading
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),

                      // Add the image above the fields
                      Image.asset(
                        'assets/signup_image.png', // Add your image to assets
                        height: 150,
                      ),
                      SizedBox(height: 20),

                      // Form
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildTextField(_firstNameController, 'First Name'),
                            _buildTextField(_lastNameController, 'Last Name'),
                            _buildTextField(_emailController, 'Email'),
                            _buildTextField(_phoneController, 'Phone'),
                            _buildPasswordField(
                                _passwordController, 'Password'),
                            _buildPasswordField(
                                _confirmPasswordController, 'Confirm Password'),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      // Sign Up Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD9B845), // Yellow color
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: _signUp,
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
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

  // Input Field Widget
  Widget _buildTextField(TextEditingController controller, String hintText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $hintText';
          }
          return null;
        },
      ),
    );
  }

  // Password Field Widget
  Widget _buildPasswordField(
      TextEditingController controller, String hintText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          suffixIcon: Icon(Icons.lock_outline, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $hintText';
          }
          if (hintText == 'Confirm Password' &&
              value != _passwordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
      ),
    );
  }
}
