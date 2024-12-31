import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({super.key});

  @override
  SuccessPageState createState() => SuccessPageState();
}

class SuccessPageState extends State<SuccessPage> {
  bool _isLoading = false; // Pour gérer l'état de chargement
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _logEvent(); // Appel de l'enregistrement de l'événement
  }

  Future<void> _logEvent() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Accès au client Supabase
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null) {
        setState(() {
          _errorMessage = 'Aucun utilisateur connecté.';
        });
        return;
      }

      // Enregistrement de l'événement dans la base de données
      final response = await supabase.from('events').insert({
        'user_id': user.id,
        'event_type': 'Password Changed',
      });

      if (response.error != null) {
        setState(() {
          _errorMessage = 'Erreur lors de l\'enregistrement de l\'événement : ${response.error!.message}';
        });
      } else {
        setState(() {
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur inconnue: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFF1D9), // Fond vert pâle
      body: SingleChildScrollView(
        child: Column(
          children: [
            // En-tête arrondi en haut
            Container(
              height: 220,
              decoration: const BoxDecoration(
                color: Color(0xFF4A4F9A), // Bleu foncé en haut
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Center(
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white) // Indicateur de chargement
                    : Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(20),
                        child: const Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 60,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 30),

            // Texte principal
            const Text(
              'Password Changed!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),

            // Texte secondaire
            const Text(
              'Your password has been changed successfully.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Message d'erreur (si présent)
            if (_errorMessage != null) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ],

            // Bouton retour
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A4F9A), // Bleu foncé
                  foregroundColor: Colors.white, // Texte blanc
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'BACK TO LOGIN',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
