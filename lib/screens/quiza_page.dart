import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestPage extends StatefulWidget {
  final String testCode;

  TestPage({required this.testCode});

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final _answerController = TextEditingController();
  String _feedbackMessage = "";
  late Map<String, dynamic> quizData;

  @override
  void initState() {
    super.initState();
    _loadQuizData();
  }

  Future<void> _loadQuizData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(widget.testCode);
    if (data != null) {
      setState(() {
        quizData = jsonDecode(data);
      });
    }
  }

  void _checkAnswer(String userAnswer, String correctAnswer) {
    setState(() {
      _feedbackMessage = userAnswer.trim().toLowerCase() == correctAnswer.trim().toLowerCase()
          ? "Réponse correcte ! Félicitations !"
          : "Réponse incorrecte. Essayez encore.";
    });
  }

  @override
  Widget build(BuildContext context) {
    if (quizData == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Erreur")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    String question = quizData['question'];
    String correctAnswer = quizData['correctAnswer'];
    List<String> possibleAnswers = quizData['possibleAnswers'].split(',');
    int duration = quizData['duration'];

    return Scaffold(
      appBar: AppBar(title: Text("Test")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Question: $question",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text("Durée: $duration secondes"),
            SizedBox(height: 20),
            Text("Réponses possibles:"),
            ...possibleAnswers.map((answer) => Text(answer)).toList(),
            SizedBox(height: 20),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(labelText: "Entrez votre réponse"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _checkAnswer(_answerController.text, correctAnswer),
              child: Text("Vérifier la réponse"),
            ),
            SizedBox(height: 20),
            Text(_feedbackMessage),
          ],
        ),
      ),
    );
  }
}
