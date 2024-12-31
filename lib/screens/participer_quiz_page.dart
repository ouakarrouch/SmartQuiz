import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quiza_page.dart'; // Assurez-vous que ce fichier est importé

class ParticiperQuizPage extends StatefulWidget {
  @override
  _ParticiperQuizPageState createState() => _ParticiperQuizPageState();
}

class _ParticiperQuizPageState extends State<ParticiperQuizPage> {
  final _codeController = TextEditingController();
  String _feedbackMessage = "";

  Future<void> _checkQuizCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String code = _codeController.text.trim();
    String? quizData = prefs.getString(code);

    if (quizData != null) {
      Map<String, dynamic> quiz = jsonDecode(quizData);
      setState(() {
        _feedbackMessage = "Quiz trouvé: ${quiz['question']} (Catégorie: ${quiz['category']}, Durée: ${quiz['duration']}s)";
      });
      // Naviguer vers la page TestPage avec le code du quiz
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TestPage(testCode: code),
        ),
      );
    } else {
      setState(() {
        _feedbackMessage = "Code incorrect";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Participer au Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: InputDecoration(labelText: "Entrez le code du quiz"),
            ),
            ElevatedButton(
              onPressed: _checkQuizCode,
              child: Text("Vérifier le code"),
            ),
            SizedBox(height: 20),
            Text(_feedbackMessage),
          ],
        ),
      ),
    );
  }
}
