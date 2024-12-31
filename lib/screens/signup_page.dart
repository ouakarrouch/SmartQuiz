import 'package:flutter/material.dart';
import 'package:quiz/utils/auth_gate.dart';
import 'package:quiz/utils/auth_service.dart';

class SignUpPage extends StatefulWidget {
  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final AuthService _authService = AuthService(); // Utilisation d'AuthService
  String? _errorMessage;

  Future<void> _signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Récupérer les données du formulaire
        final firstName = _firstNameController.text;
        final lastName = _lastNameController.text;
        final email = _emailController.text;
        final phone = _phoneController.text;
        final password = _passwordController.text;
        final confirmPassword = _confirmPasswordController.text;

        // Appel de la méthode signUp d'AuthService
        await _authService.signUp(
          firstName,
          lastName,
          email,
          phone,
          password,
          confirmPassword,
        );

        // Check if the widget is still mounted before performing navigation
        if (mounted) {
          // Redirection vers la page de connexion après une inscription réussie
          Navigator.pushReplacementNamed(context, '/login');
        }
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
        _showError(_errorMessage ?? 'An unexpected error occurred.');
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
      backgroundColor: const Color(0xFF4A4FA8), // Purple background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  'Back',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 10),

              // Centered Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Sign Up Heading
                      const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Add the image above the fields
                      Image.asset(
                        'assets/signup_image.png', // Add your image to assets
                        height: 150,
                      ),
                      const SizedBox(height: 20),

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

                      const SizedBox(height: 20),

                      // Sign Up Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFD9B845), // Yellow color
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: _signUp,
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),

                      // Display error message (if any)
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
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
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
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
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
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
