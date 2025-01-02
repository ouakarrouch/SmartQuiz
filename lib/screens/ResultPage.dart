import 'package:flutter/material.dart';
import 'package:quiz/screens/home_page.dart'; // Assurez-vous que cette importation est correcte

class ResultPage extends StatelessWidget {
  final int score; // Score correct renvoyé par la page précédente
  final int totalQuestions;
  final String firstName; // Prénom de l'utilisateur
  final String lastName; // Nom de l'utilisateur
  final String theme; // Thème du quiz

  const ResultPage({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.firstName,
    required this.lastName,
    required this.theme, // Ajout du thème du quiz
  });

  // Fonction pour calculer le pourcentage de bonnes réponses
  double calculatePercentage() {
    return (score / totalQuestions) * 100;
  }

  // Fonction pour personnaliser le message en fonction du score
  String getResultMessage() {
    final percentage = calculatePercentage();
    if (percentage >= 90) {
      return 'Excellent travail !';
    } else if (percentage >= 70) {
      return 'Bien joué !';
    } else if (percentage >= 50) {
      return 'Pas mal, mais vous pouvez faire mieux !';
    } else {
      return 'Ne vous découragez pas, continuez à apprendre !';
    }
  }

  @override
  Widget build(BuildContext context) {
    final percentage = calculatePercentage();
    final resultMessage = getResultMessage();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.purple],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                theme, // Afficher le thème du quiz
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Votre Score',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '$score/$totalQuestions',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '(${percentage.toStringAsFixed(1)}%)', // Afficher le pourcentage
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  children: [
                    const TextSpan(text: 'Félicitations, '),
                    TextSpan(
                      text: '$firstName $lastName', // Afficher le prénom et le nom
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const TextSpan(text: ' !'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                resultMessage, // Message personnalisé en fonction du score
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Retour à l'accueil (HomePage) en remplaçant la page actuelle
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(), // Remplacez par votre page d'accueil
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}