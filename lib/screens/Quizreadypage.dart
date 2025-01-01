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
        title: Text(theme), // Affiche le thème comme titre
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Texte conditionnel en fonction du thème
              if (theme.toLowerCase() == 'histoire')
                const Text(
                  "C'est parti pour un voyage dans le temps ?",
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                )
              else
                const Text(
                  "Prêt pour ce quiz passionnant ?",
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
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
                child: const Text("Prêt"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
