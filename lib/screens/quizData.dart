import 'package:flutter/material.dart';

class QuizPage extends StatelessWidget {
  final Map<String, dynamic> quizData; // Paramètre pour les données du quiz

  QuizPage({required this.quizData}); // Constructeur avec paramètre nommé

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz - ${quizData['theme']}"),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          "Quiz en cours pour le thème : ${quizData['theme']}",
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
