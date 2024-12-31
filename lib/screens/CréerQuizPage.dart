import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreerQuizPage extends StatefulWidget {
  @override
  _CreerQuizPageState createState() => _CreerQuizPageState();
}

class _CreerQuizPageState extends State<CreerQuizPage> {
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  final _categoryController = TextEditingController();
  final _durationController = TextEditingController();
  final _possibleAnswersController = TextEditingController();
  final _correctAnswerController = TextEditingController();
  String _quizType = "public"; // Type de quiz par défaut

  // Générer un code unique de 4 chiffres pour le quiz
  String _generateCode() {
    final random = Random();
    return (random.nextInt(9000) + 1000).toString(); // Génère un nombre entre 1000 et 9999
  }

  // Sauvegarder un quiz dans SharedPreferences
  Future<void> _saveQuiz(String code, String question, String correctAnswer, String category, String possibleAnswers, String quizType, int duration) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> quizData = {
      'question': question,
      'correctAnswer': correctAnswer,
      'category': category,
      'possibleAnswers': possibleAnswers,
      'quizType': quizType,
      'duration': duration,
    };
    await prefs.setString(code, jsonEncode(quizData));
    print("Quiz sauvegardé avec le code : $code");
  }

  // Créer un quiz
  void _createQuiz() {
    String code = _generateCode();
    String question = _questionController.text.trim();
    String correctAnswer = _correctAnswerController.text.trim();
    String category = _categoryController.text.trim();
    String possibleAnswers = _possibleAnswersController.text.trim();
    int duration = int.tryParse(_durationController.text.trim()) ?? 0;

    if (question.isNotEmpty && correctAnswer.isNotEmpty && category.isNotEmpty && possibleAnswers.isNotEmpty && duration > 0) {
      _saveQuiz(code, question, correctAnswer, category, possibleAnswers, _quizType, duration);

      String message = _quizType == "public"
          ? "Votre quiz a été créé avec succès et est public."
          : "Votre code de quiz privé est : $code";

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Quiz créé"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Ok"),
            ),
          ],
        ),
      );
    } else {
      // Gérer les champs vides
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Veuillez remplir tous les champs."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Créer un Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: "Entrez votre question"),
            ),
            TextField(
              controller: _possibleAnswersController,
              decoration: InputDecoration(labelText: "Entrez les réponses possibles (séparées par des virgules)"),
            ),
            TextField(
              controller: _correctAnswerController,
              decoration: InputDecoration(labelText: "Entrez la réponse correcte"),
            ),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: "Entrez la catégorie du quiz"),
            ),
            TextField(
              controller: _durationController,
              decoration: InputDecoration(labelText: "Entrez la durée en secondes"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => _quizType = "public"),
                  child: Text("Public"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _quizType == "public" ? Colors.blue : Colors.grey,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => setState(() => _quizType = "privé"),
                  child: Text("Privé"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _quizType == "privé" ? Colors.blue : Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createQuiz,
              child: Text("Créer le Quiz"),
            ),
          ],
        ),
      ),
    );
  }
}
