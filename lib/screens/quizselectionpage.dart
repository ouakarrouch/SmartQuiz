import 'package:flutter/material.dart';
import 'package:quiz/screens/Quizpage.dart'; // Import de la page QuizPage

class QuizSelectionPage extends StatelessWidget {
  final List<String> quizzes = ['Quiz1', 'Quiz2']; // Seuls Quiz1 et Quiz2 sont inclus

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sélectionnez un Quiz',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: quizzes.length, // Seuls Quiz1 et Quiz2 sont affichés
            itemBuilder: (context, index) {
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(
                    quizzes[index],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4E55A1),
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: const Color(0xFF4E55A1),
                  ),
                  onTap: () {
                    // Rediriger vers la QuizPage avec le thème "Histoire"
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizPage(
                          timeLimit: 30, // Limite de temps en secondes
                          theme: "Histoire", // Thème du quiz
                          quizCode: quizzes[index], // Code du quiz
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}