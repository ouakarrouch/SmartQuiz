import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

class CreateQuizPage extends StatefulWidget {
  @override
  _CreateQuizPageState createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final _formKey = GlobalKey<FormState>();
  int _numberOfQuestions = 0;
  List<Map<String, dynamic>> _questions = [];
  String _selectedTheme = 'Sport';
  String _selectedDifficulty = 'Facile';
  bool _isPrivate = false;
  int _timeLimit = 30;

  // Drop-down menu options
  List<String> themes = ['Sport', 'Cinéma', 'Histoire', 'Géographie', 'Sciences', 'Musique'];
  List<String> difficulties = ['Facile', 'Moyen', 'Difficile'];

  // Dynamically create the question fields
  void _generateQuestionFields() {
    _questions = List.generate(_numberOfQuestions, (index) {
      return {
        'question': '',
        'answer1': '',
        'answer2': '',
        'answer3': '',
        'correctAnswer': 1,
      };
    });
  }

  // Function to check if all fields are filled correctly
  bool _areFieldsFilled() {
    if (_selectedTheme.isEmpty || _selectedDifficulty.isEmpty) {
      return false;
    }

    if (_numberOfQuestions == 0) {
      return false;
    }

    for (var question in _questions) {
      if (question['question'].isEmpty ||
          question['answer1'].isEmpty ||
          question['answer2'].isEmpty ||
          question['answer3'].isEmpty ||
          question['correctAnswer'] == null) {
        return false;
      }
    }

    return true;
  }

  Future<void> _submitQuiz() async {
  if (_formKey.currentState!.validate() && _areFieldsFilled()) {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Utilisateur non connecté, impossible de créer le quiz.')));
      return;
    }

    try {
      // Générer un code de quiz aléatoire uniquement si le quiz est privé
      String quizCode = _isPrivate
          ? Random().nextInt(9000).toString().padLeft(4, '0')
          : ''; // Pas de code pour les quiz publics

      // Insert quiz data into the 'quiz' table
      final response = await Supabase.instance.client
          .from('quiz')
          .upsert([
            {
              'theme': _selectedTheme,
              'difficulty': _selectedDifficulty,
              'number_of_questions': _numberOfQuestions,
              'time_limit': _timeLimit,
              'is_private': _isPrivate,
              'quiz_code': quizCode, // Code vide pour les quiz publics
              'creator_id': userId,
            }
          ])
          .select()
          .single();

      if (response != null) {
        final quizId = response['id'];

        // Insert questions into the 'quiz_questions' table
        for (int i = 0; i < _questions.length; i++) {
          await Supabase.instance.client.from('quiz_questions').upsert([
            {
              'quiz_id': quizId,
              'question_text': _questions[i]['question'],
              'answer1': _questions[i]['answer1'],
              'answer2': _questions[i]['answer2'],
              'answer3': _questions[i]['answer3'],
              'correct_answer': _questions[i]['correctAnswer'],
              'time_limit': _timeLimit,
            }
          ]);
        }

        // Afficher un message de succès
        _showSuccessDialog(isPrivate: _isPrivate, quizCode: quizCode);
      } else {
        throw Exception('Erreur lors de la création du quiz');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la création du quiz: $e')));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text('Veuillez remplir tous les champs avant de soumettre.')));
  }
}
  // Afficher le dialogue de succès
  void _showSuccessDialog({required bool isPrivate, required String quizCode}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 50),
              SizedBox(height: 16),
              Text('Quiz Créé', style: TextStyle(fontSize: 20)),
              if (isPrivate) ...[
                SizedBox(height: 16),
                Text('CODE', style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: quizCode.split('').map((char) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        char,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                ),
              ],
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Fermer le dialogue
                  Navigator.of(context).pop();
                  // Rediriger vers la page Home
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home', // Remplacez par le nom de votre route vers la page Home
                    (route) => false,
                  );
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Créer un Quiz',
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dropdown for theme
                  DropdownButtonFormField<String>(
                    value: _selectedTheme,
                    decoration: InputDecoration(
                      labelText: 'Choisir le thème',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    dropdownColor: const Color(0xFF6A72C1),
                    style: TextStyle(color: Colors.white),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedTheme = newValue!;
                      });
                    },
                    items: themes.map((theme) {
                      return DropdownMenuItem(
                        value: theme,
                        child: Text(theme),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),

                  // Dropdown for difficulty
                  DropdownButtonFormField<String>(
                    value: _selectedDifficulty,
                    decoration: InputDecoration(
                      labelText: 'Difficulté',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    dropdownColor: const Color(0xFF6A72C1),
                    style: TextStyle(color: Colors.white),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedDifficulty = newValue!;
                      });
                    },
                    items: difficulties.map((difficulty) {
                      return DropdownMenuItem(
                        value: difficulty,
                        child: Text(difficulty),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),

                  // Number of questions field
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Nombre de questions',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) {
                      setState(() {
                        _numberOfQuestions = int.tryParse(value) ?? 0;
                        _generateQuestionFields();
                      });
                    },
                  ),
                  SizedBox(height: 16),

                  // Generate questions dynamically
                  if (_numberOfQuestions > 0) ...[
                    ...List.generate(_numberOfQuestions, (index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Question ${index + 1}',
                              labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                            onChanged: (value) {
                              setState(() {
                                _questions[index]['question'] = value;
                              });
                            },
                          ),
                          SizedBox(height: 16), // Espacement ajouté
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Réponse 1',
                              labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                            onChanged: (value) {
                              setState(() {
                                _questions[index]['answer1'] = value;
                              });
                            },
                          ),
                          SizedBox(height: 16), // Espacement ajouté
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Réponse 2',
                              labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                            onChanged: (value) {
                              setState(() {
                                _questions[index]['answer2'] = value;
                              });
                            },
                          ),
                          SizedBox(height: 16), // Espacement ajouté
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Réponse 3',
                              labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                            onChanged: (value) {
                              setState(() {
                                _questions[index]['answer3'] = value;
                              });
                            },
                          ),
                          SizedBox(height: 16), // Espacement ajouté
                          DropdownButtonFormField<int>(
                            value: _questions[index]['correctAnswer'],
                            decoration: InputDecoration(
                              labelText: 'Réponse correcte',
                              labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            dropdownColor: const Color(0xFF6A72C1),
                            style: TextStyle(color: Colors.white),
                            onChanged: (value) {
                              setState(() {
                                _questions[index]['correctAnswer'] = value!;
                              });
                            },
                            items: [1, 2, 3].map((answer) {
                              return DropdownMenuItem(
                                value: answer,
                                child: Text('Réponse $answer'),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 24), // Espacement accru
                        ],
                      );
                    }),
                  ],

                  // Quiz type selection using checkboxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Public',
                            style: TextStyle(color: Colors.white),
                          ),
                          Checkbox(
                            value: !_isPrivate,
                            onChanged: (value) {
                              setState(() {
                                _isPrivate = !value!;
                              });
                            },
                            fillColor: MaterialStateProperty.resolveWith<Color>(
                                (states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.white;
                              }
                              return Colors.white.withOpacity(0.2);
                            }),
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      Column(
                        children: [
                          Text(
                            'Privé',
                            style: TextStyle(color: Colors.white),
                          ),
                          Checkbox(
                            value: _isPrivate,
                            onChanged: (value) {
                              setState(() {
                                _isPrivate = value!;
                              });
                            },
                            fillColor: MaterialStateProperty.resolveWith<Color>(
                                (states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.white;
                              }
                              return Colors.white.withOpacity(0.2);
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Submit button
                  Center(
                    child: ElevatedButton(
                      onPressed: _areFieldsFilled() ? _submitQuiz : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD9BA3D), // Couleur du bouton
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Créer le Quiz',
                        style: TextStyle(
                          color: Colors.white, // Texte en blanc pour contraster
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}