import 'dart:math';
import 'package:flutter/material.dart';

class CreerQuizPage extends StatefulWidget {
  @override
  _CreerQuizPageState createState() => _CreerQuizPageState();
}

class _CreerQuizPageState extends State<CreerQuizPage> {
  String quizCode = "";
  String selectedTheme = "Historique"; // Valeur par défaut du thème
  String selectedDifficulty = "Facile"; // Valeur par défaut de la difficulté
  bool isPrivate = true; // Par défaut, quiz privé
  String quizTime = ""; // Temps de réponse en secondes

  // Génération de code aléatoire
  String _generateQuizCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(6, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  // Action lors de la création du quiz
  void _createQuiz() {
    if (isPrivate) {
      setState(() {
        quizCode = _generateQuizCode();
      });
      _showCustomDialog(quizCode);
    } else {
      // TODO: Ajouter le quiz à la page publique
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Quiz ajouté à la page publique!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // Affichage du code généré
  void _showCustomDialog(String code) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF00C8FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.check_box, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "Quiz Créé",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "CODE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: code.split('').map((digit) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xFF001B41),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      digit,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 100,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
            _buildDropdownMenu(),
            const SizedBox(height: 20),
            _buildQuestionSection("Question 1"),
            _buildQuestionSection("Question 2"),
            _buildQuestionSection("Question 3"),
            _buildTitleField("Temps de réponse (secondes)"),
            _buildTextField("Entrez le temps", (value) => quizTime = value),
            const SizedBox(height: 10),
            _buildTitleField("Difficulté"),
            _buildDifficultySection(),
            const SizedBox(height: 10),
            _buildPrivacySwitch(),
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

  Widget _buildDropdownMenu() {
    return DropdownButtonFormField<String>(
      value: selectedTheme,
      items: ["Historique", "Sport", "Géographique"]
          .map((theme) => DropdownMenuItem(value: theme, child: Text(theme)))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedTheme = value!;
        });
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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

  Widget _buildQuestionSection(String questionTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleField(questionTitle),
        _buildTextField("Intitulé de la question", (_) {}),
        _buildTextField("Réponse 1", (_) {}),
        _buildTextField("Réponse 2", (_) {}),
        _buildTextField("Réponse 3", (_) {}),
        const SizedBox(height: 10),
      ],
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

  Widget _buildDifficultySection() {
    return Column(
      children: ["Facile", "Moyen", "Difficile"]
          .map((difficulty) => RadioListTile<String>(
                title: Text(difficulty),
                value: difficulty,
                groupValue: selectedDifficulty,
                onChanged: (value) {
                  setState(() {
                    selectedDifficulty = value!;
                  });
                },
              ))
          .toList(),
    );
  }

  Widget _buildPrivacySwitch() {
    return Row(
      children: [
        Text("Privé"),
        Switch(
          value: isPrivate,
          onChanged: (value) {
            setState(() {
              isPrivate = value;
            });
          },
        ),
        Text("Public"),
      ],
    );
  }
}
