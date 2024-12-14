import 'dart:math';
import 'package:flutter/material.dart';

class CreerQuizPage extends StatefulWidget {
  @override
  _CreerQuizPageState createState() => _CreerQuizPageState();
}

class _CreerQuizPageState extends State<CreerQuizPage> {
  String quizCode = ""; // Variable pour stocker le code généré

  // Fonction pour générer un code aléatoire
  String _generateQuizCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(6, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  void _createQuiz() {
    // Générer un code unique pour le quiz
    setState(() {
      quizCode = _generateQuizCode();
    });

    // TODO: Sauvegarder les informations du quiz avec le code généré dans une base de données ou mémoire locale

    // Afficher le code à l'utilisateur
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Quiz Créé !"),
        content: Text("Code du quiz : $quizCode"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
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
            _buildTitleField("Thème"),
            _buildTextField("Nom du thème"),
            const SizedBox(height: 20),
            _buildQuestionSection("Question 1"),
            _buildQuestionSection("Question 2"),
            _buildQuestionSection("Question 3"),
            const SizedBox(height: 20),
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 20.0,
                  ),
                  child: Text(
                    "Créer",
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

  Widget _buildTextField(String hint) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextField(
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

  Widget _buildQuestionSection(String questionTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleField(questionTitle),
        _buildTextField("Intitulé de la question"),
        const SizedBox(height: 10),
        _buildTextField("Réponse 1"),
        _buildTextField("Réponse 2"),
        _buildTextField("Réponse 3"),
      ],
    );
  }
}
