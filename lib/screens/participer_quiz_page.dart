import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quiz_confirmation_page.dart';

class ParticiperQuizPage extends StatefulWidget {
  @override
  _ParticiperQuizPageState createState() => _ParticiperQuizPageState();
}

class _ParticiperQuizPageState extends State<ParticiperQuizPage> {
  final TextEditingController codeController = TextEditingController();

  Future<void> _searchQuiz() async {
    String enteredCode = codeController.text.trim();
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(enteredCode)) {
      String? quizJson = prefs.getString(enteredCode);
      Map<String, dynamic> quizData = jsonDecode(quizJson!);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizConfirmationPage(quizData: quizData),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Code Incorrect"),
          content: const Text("Aucun quiz trouvé avec ce code."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB2E0F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Participer à un Quiz",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Confiance en toi, tu es prêt !",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: codeController,
                  decoration: InputDecoration(
                    hintText: "Entrez le code du quiz",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _searchQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 40),
                ),
                child: const Text(
                  "Participer",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
