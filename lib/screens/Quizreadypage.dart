import 'package:flutter/material.dart';
import 'package:quiz/screens/Quizpage.dart';

class QuizReadyPage extends StatelessWidget {
  final String theme;
  final String quizId; // ID du quiz
  final VoidCallback onReady;

  const QuizReadyPage({
    super.key,
    required this.theme,
    required this.quizId,
    required this.onReady,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Prêt pour le Quiz?",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4E55A1),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4E55A1),
              Color(0xFF6A72C1),
            ],
          ),
        ),
        child: Center( // Centrer le contenu
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centrer verticalement
              children: [
                // Titre du quiz
                Text(
                  " $theme ",
                  style: const TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black45,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Illustration ou icône
                Icon(
                  Icons.quiz,
                  size: 120,
                  color: Colors.white.withOpacity(0.9),
                ),
                const SizedBox(height: 30),

                // Message d'encouragement
                const Text(
                  "Êtes-vous prêt à relever le défi ?",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.black45,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Bouton "Commencer"
                ElevatedButton(
                  onPressed: () {
                    onReady(); // Appelle la fonction onReady
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 8,
                    shadowColor: Colors.black.withOpacity(0.3),
                  ),
                  child: const Text(
                    "Commencer",
                    style: TextStyle(
                      color: Color(0xFF4E55A1),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}