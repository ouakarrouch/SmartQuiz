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
  final _noteController = TextEditingController();
  String _quizType = "public"; // Type de quiz par défaut

  // Générer un code unique de 4 chiffres pour le quiz
  String _generateCode() {
    final random = Random();
    return (random.nextInt(9000) + 1000).toString(); // Génère un nombre entre 1000 et 9999
  }

  // Sauvegarder un quiz dans SharedPreferences
  Future<void> _saveQuiz(String code, String question, String correctAnswer, String category, String possibleAnswers, String quizType, int duration, String note) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> quizData = {
      'question': question,
      'correctAnswer': correctAnswer,
      'category': category,
      'possibleAnswers': possibleAnswers,
      'quizType': quizType,
      'duration': duration,
      'note': note,
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
    String note = _noteController.text.trim();

    if (question.isNotEmpty && correctAnswer.isNotEmpty && category.isNotEmpty && possibleAnswers.isNotEmpty && duration > 0 && note.isNotEmpty) {
      _saveQuiz(code, question, correctAnswer, category, possibleAnswers, _quizType, duration, note);

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
      backgroundColor: const Color(0xFFB2E0F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Créer Quiz",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleField("Entrez votre question"),
            _buildTextField("Entrez votre question", (value) => _questionController.text = value),
            const SizedBox(height: 20),
            _buildTitleField("Réponses possibles"),
            _buildTextField("Réponses possibles (séparées par des virgules)", (value) => _possibleAnswersController.text = value),
            const SizedBox(height: 20),
            _buildTitleField("Réponse correcte"),
            _buildTextField("Réponse correcte", (value) => _correctAnswerController.text = value),
            const SizedBox(height: 20),
            _buildTitleField("Catégorie"),
            _buildTextField("Catégorie du quiz", (value) => _categoryController.text = value),
            const SizedBox(height: 20),
            _buildTitleField("Durée en secondes"),
            _buildTextField("Entrez la durée", (value) => _durationController.text = value),
            const SizedBox(height: 20),
            _buildTitleField("Note pour chaque question"),
            _buildTextField("Note (ex: 10)", (value) => _noteController.text = value),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => _quizType = "public"),
                  child: Text("Public"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _quizType == "public" ? Colors.blue : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => setState(() => _quizType = "privé"),
                  child: Text("Privé"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _quizType == "privé" ? Colors.blue : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _createQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                  child: Text(
                    "Créer le Quiz",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black54,
      ),
    );
  }
}
