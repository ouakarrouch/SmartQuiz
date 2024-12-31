import 'package:flutter/material.dart';
import 'create_password_page.dart';

class VerificationCodePage extends StatefulWidget {
  const VerificationCodePage({super.key});

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());
  String? _errorMessage; // Variable pour stocker le message d'erreur

  // Méthode pour récupérer le code entré
  String _getVerificationCode() {
    return _controllers.map((controller) => controller.text).join();
  }

  // Méthode pour valider et soumettre le code
  void _submitCode() {
    final code = _getVerificationCode();

    if (code.length < 4) {
      setState(() {
        _errorMessage =
            'Veuillez entrer un code complet.'; // Mise à jour du message d'erreur
      });
      return;
    }

    // Logique pour valider le code avec le backend
    // Exemple d'appel à une API :
    // bool isValid = await AuthService().validateVerificationCode(code);
    const bool isValid = true; // Exemple de validation réussie.

    if (isValid) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreatePasswordPage()),
      );
    } else {
      setState(() {
        _errorMessage =
            'Code incorrect. Veuillez réessayer.'; // Mise à jour du message d'erreur
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A4F9A), // Fond bleu foncé
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Reset Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Back',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Texte d'en-tête
            const Text(
              'Enter Verification Code',
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Champs de code de vérification
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  width: 55, // Largeur de chaque case
                  height: 60,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 5), // Espacement réduit
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _controllers[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLength: 1,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        // Focus automatique sur la prochaine case
                        if (index < 3) {
                          FocusScope.of(context).nextFocus();
                        }
                      } else {
                        // Retour à la case précédente si suppression
                        if (index > 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      }
                    },
                  ),
                );
              }),
            ),

            // Affichage du message d'erreur s'il y en a un
            if (_errorMessage != null) ...[
              const SizedBox(height: 15),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ],

            const SizedBox(height: 30),

            // Bouton "Submit"
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF298CFF), // Bleu bouton
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'SUBMIT',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Texte pour renvoyer le code
            TextButton(
              onPressed: () {
                // Logique pour renvoyer le code
                print("Code resent to user's email.");
              },
              child: const Text(
                'Resend code',
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
