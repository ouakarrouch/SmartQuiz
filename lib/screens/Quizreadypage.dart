import 'package:flutter/material.dart';
import 'package:quiz/screens/QuizPage.dart'; // Assurez-vous d'importer la page QuizPage


class QuizReadyPage extends StatelessWidget {
  final String theme; // Thème du quiz
  final String quizCode; // Code unique pour identifier le quiz
  final int timeLimit; // Limite de temps pour le quiz (en secondes)
  final VoidCallback onReady; // Callback lorsqu'on est prêt

  const QuizReadyPage({
    super.key,
    required this.theme,
    required this.quizCode,
    required this.timeLimit,
    required this.onReady,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          theme,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false, // Désactive le bouton de retour
        backgroundColor: const Color(0xFF4E55A1),
        elevation: 0,
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Texte conditionnel en fonction du thème
                if (theme.toLowerCase() == 'histoire')
                  const Text(
                    "C'est parti pour un voyage dans le temps ?",
                    style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )
                else
                  const Text(
                    "Prêt pour ce quiz passionnant ?",
                    style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // Redirection vers la page QuizPage avec les paramètres nécessaires
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizPage(
                          theme: theme, // Passe le thème
                          quizCode: quizCode, // Passe le code du quiz
                          timeLimit: timeLimit, // Passe la limite de temps
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Prêt",
                    style: TextStyle(
                      color: Color(0xFF4E55A1),
                      fontSize: 18,
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