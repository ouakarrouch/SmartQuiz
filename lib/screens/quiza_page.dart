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
  int _remainingTime = 0;
  int _score = 0;
  late String correctAnswer;
  bool _quizEnded = false;
  late String question;
  late List<String> possibleAnswers;

  @override
  void initState() {
    super.initState();
    _loadQuizData();
  }

  // Chargement des données du quiz à partir de SharedPreferences
  Future<void> _loadQuizData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(widget.testCode);
    if (data != null) {
      setState(() {
        quizData = jsonDecode(data);
        correctAnswer = quizData['correctAnswer'];
        _remainingTime = quizData['duration'];
        question = quizData['question'];
        possibleAnswers = quizData['possibleAnswers'].split(',');
      });
      _startTimer();
    }
  }

  // Démarre le chronomètre
  void _startTimer() {
    if (_remainingTime > 0 && !_quizEnded) {
      Future.delayed(Duration(seconds: 1), () {
        if (_remainingTime > 0 && !_quizEnded) {
          setState(() {
            _remainingTime--;
          });
          _startTimer();
        } else {
          _endQuiz();
        }
      });
    }
  }

  // Fin du quiz et affichage du score
  void _endQuiz() {
    setState(() {
      _quizEnded = true;
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Quiz terminé"),
        content: Text("Votre score final est : $_score/${possibleAnswers.length}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Ok"),
          ),
        ],
      ),
    );
  }

  // Vérifie la réponse de l'utilisateur
  void _checkAnswer(String userAnswer) {
    if (_quizEnded) return; // Empêche de vérifier une réponse après la fin du quiz

    setState(() {
      if (userAnswer.trim().toLowerCase() == correctAnswer.trim().toLowerCase()) {
        _score++;
      }
      _feedbackMessage = userAnswer.trim().toLowerCase() == correctAnswer.trim().toLowerCase()
          ? "Réponse correcte !"
          : "Réponse incorrecte.";
    });

    // Si la durée est terminée ou que toutes les réponses sont données, le quiz doit se terminer.
    if (_remainingTime <= 0) {
      _endQuiz();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (quizData.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Erreur")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFB2E0F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Test",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
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
            Text(
              "Temps restant: $_remainingTime secondes",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "Réponses possibles:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...possibleAnswers.map((answer) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(answer, style: TextStyle(fontSize: 16)),
            )),
            SizedBox(height: 20),
            TextField(
              controller: _answerController,
              enabled: !_quizEnded, // Désactive le champ de réponse si le quiz est terminé
              decoration: InputDecoration(
                labelText: "Entrez votre réponse",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _quizEnded
                  ? null
                  : () {
                      _checkAnswer(_answerController.text);
                    },
              child: Text("Vérifier la réponse"),
              style: ElevatedButton.styleFrom(
                backgroundColor: _quizEnded ? Colors.grey : Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              _feedbackMessage,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            if (_quizEnded)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Votre score final : $_score/${possibleAnswers.length}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
