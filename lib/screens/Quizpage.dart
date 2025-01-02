import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:quiz/screens/ResultPage.dart';

class QuizPage extends StatefulWidget {
  final int timeLimit; // Limite de temps en secondes pour chaque question
  final String theme; // Thème du quiz
  final String quizCode; // Code du quiz pour récupérer les données

  const QuizPage({
    super.key,
    required this.timeLimit,
    required this.theme,
    required this.quizCode,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late int remainingTime; // Temps restant pour la question actuelle
  Timer? countdownTimer;
  String quizTitle = ""; // Titre du quiz récupéré depuis la base de données
  List<Map<String, dynamic>> questions = []; // Liste de toutes les questions
  int currentQuestionIndex = 0; // Index de la question actuelle
  int totalQuestions = 0; // Nombre total de questions du quiz
  int correctAnswers = 0; // Nombre de réponses correctes
  String firstName = ""; // Prénom de l'utilisateur
  String lastName = ""; // Nom de l'utilisateur

  @override
  void initState() {
    super.initState();
    remainingTime = widget.timeLimit; // Initialiser le temps pour la première question
    fetchQuizTitle(); // Récupération du titre du quiz
    fetchAllQuestions(); // Récupération de toutes les questions
    fetchUserInfo(); // Récupération des informations de l'utilisateur
    startCountdown(); // Démarrer le chronomètre pour la première question
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  // Fonction pour récupérer le titre du quiz depuis la base de données
  Future<void> fetchQuizTitle() async {
    try {
      final response = await Supabase.instance.client
          .from('quiz') // Nom de la table
          .select('theme') // Colonne à récupérer
          .eq('quiz_code', widget.quizCode) // Filtrer par code du quiz
          .maybeSingle();

      if (response != null && response['theme'] != null) {
        setState(() {
          quizTitle = response['theme'];
        });
      } else {
        setState(() {
          quizTitle = "Quiz"; // Titre par défaut si non trouvé
        });
      }
    } catch (e) {
      setState(() {
        quizTitle = "Erreur"; // Afficher une erreur si la requête échoue
      });
    }
  }

  // Fonction pour récupérer toutes les questions du quiz
  Future<void> fetchAllQuestions() async {
    try {
      // Récupérer l'ID du quiz à partir de 'quiz_code'
      final quizResponse = await Supabase.instance.client
          .from('quiz')
          .select('id')
          .eq('quiz_code', widget.quizCode)
          .limit(1)
          .maybeSingle();

      if (quizResponse != null && quizResponse['id'] != null) {
        final quizId = quizResponse['id'];

        // Récupérer toutes les questions et réponses à partir de 'quiz_questions'
        final response = await Supabase.instance.client
            .from('quiz_questions')
            .select('question_text, answer1, answer2, answer3, correct_answer')
            .eq('quiz_id', quizId) // Utiliser 'quiz_id' pour filtrer les questions
            .order('id', ascending: true); // Trier par ID pour garder l'ordre

        if (response != null && response.isNotEmpty) {
          setState(() {
            questions = response;
            totalQuestions = questions.length;
          });
        } else {
          setState(() {
            questions = [];
            totalQuestions = 0;
          });
        }
      } else {
        setState(() {
          questions = [];
          totalQuestions = 0;
        });
      }
    } catch (e) {
      setState(() {
        questions = [];
        totalQuestions = 0;
      });
    }
  }

  // Fonction pour récupérer les informations de l'utilisateur
  Future<void> fetchUserInfo() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id; // Récupérer l'ID de l'utilisateur connecté
      if (userId != null) {
        final response = await Supabase.instance.client
            .from('users') // Nom de la table
            .select('first_name, last_name, score') // Colonnes à récupérer
            .eq('id', userId) // Filtrer par ID de l'utilisateur
            .maybeSingle();

        if (response != null) {
          setState(() {
            firstName = response['first_name'] ?? "Utilisateur";
            lastName = response['last_name'] ?? "";
          });
        }
      }
    } catch (e) {
      print('Erreur lors de la récupération des informations de l\'utilisateur: $e');
    }
  }

  // Fonction pour mettre à jour le score de l'utilisateur
  Future<void> updateUserScore(int newScore) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id; // Récupérer l'ID de l'utilisateur connecté
      if (userId != null) {
        // Récupérer le score actuel de l'utilisateur
        final response = await Supabase.instance.client
            .from('users') // Nom de la table
            .select('score') // Colonne à récupérer
            .eq('id', userId) // Filtrer par ID de l'utilisateur
            .maybeSingle();

        if (response != null) {
          final currentScore = response['score'] ?? 0; // Récupérer le score actuel (ou 0 si null)
          final updatedScore = currentScore + newScore; // Ajouter le nouveau score

          // Mettre à jour le score dans la base de données
          await Supabase.instance.client
              .from('users')
              .update({'score': updatedScore})
              .eq('id', userId);
        }
      }
    } catch (e) {
      print('Erreur lors de la mise à jour du score: $e');
    }
  }

  void startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        timer.cancel();
        // Passer directement à la question suivante ou terminer le quiz
        goToNextQuestion();
      }
    });
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void goToNextQuestion() {
    if (currentQuestionIndex < totalQuestions - 1) {
      setState(() {
        currentQuestionIndex++; // Passer à la question suivante
        remainingTime = widget.timeLimit; // Réinitialiser le temps pour la nouvelle question
      });
      countdownTimer?.cancel();
      startCountdown(); // Redémarrer le chronomètre pour la nouvelle question
    } else {
      // Si c'est la dernière question, naviguer vers ResultPage
      navigateToResultPage();
    }
  }

  void checkAnswer(int selectedAnswer) {
    final currentQuestion = questions[currentQuestionIndex];
    final correctAnswer = currentQuestion['correct_answer'];

    if (selectedAnswer == correctAnswer) {
      setState(() {
        correctAnswers++; // Incrémenter le nombre de réponses correctes
      });
    }

    if (currentQuestionIndex < totalQuestions - 1) {
      goToNextQuestion();
    } else {
      navigateToResultPage();
    }
  }

  void navigateToResultPage() {
    // Mettre à jour le score dans la base de données
    updateUserScore(correctAnswers);

    // Naviguer vers la page de résultats
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          score: correctAnswers, // Score basé sur les réponses correctes
          totalQuestions: totalQuestions,
          firstName: firstName, // Prénom de l'utilisateur
          lastName: lastName, // Nom de l'utilisateur
          theme: widget.theme, // Passer le thème du quiz
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions.isNotEmpty ? questions[currentQuestionIndex] : null;
    final isLastQuestion = currentQuestionIndex == totalQuestions - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          quizTitle.isEmpty ? 'Chargement...' : quizTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4E55A1),
        elevation: 0,
        automaticallyImplyLeading: false, // Désactive le bouton de retour
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Progression et compte à rebours
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${currentQuestionIndex + 1}/$totalQuestions',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      formatTime(remainingTime),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Question
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  currentQuestion?['question_text'] ?? 'Chargement de la question...',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Affichage des réponses
              Column(
                children: [
                  AnswerTile(
                    answer: currentQuestion?['answer1'] ?? 'Réponse 1 non trouvée',
                    onTap: () {
                      checkAnswer(1); // Vérifier si la réponse 1 est correcte
                    },
                  ),
                  AnswerTile(
                    answer: currentQuestion?['answer2'] ?? 'Réponse 2 non trouvée',
                    onTap: () {
                      checkAnswer(2); // Vérifier si la réponse 2 est correcte
                    },
                  ),
                  AnswerTile(
                    answer: currentQuestion?['answer3'] ?? 'Réponse 3 non trouvée',
                    onTap: () {
                      checkAnswer(3); // Vérifier si la réponse 3 est correcte
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Bouton suivant ou terminer
              ElevatedButton(
                onPressed: isLastQuestion ? navigateToResultPage : goToNextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  isLastQuestion ? 'Terminer' : 'Suivant',
                  style: const TextStyle(
                    color: Color(0xFF4E55A1),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget pour afficher les réponses
class AnswerTile extends StatefulWidget {
  final String answer;
  final VoidCallback onTap;

  const AnswerTile({
    Key? key,
    required this.answer,
    required this.onTap,
  }) : super(key: key);

  @override
  _AnswerTileState createState() => _AnswerTileState();
}

class _AnswerTileState extends State<AnswerTile> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isTapped = true; // Activer l'effet de clic
        });
        Future.delayed(const Duration(milliseconds: 200), () {
          setState(() {
            _isTapped = false; // Désactiver l'effet de clic après un court délai
          });
          widget.onTap(); // Exécuter l'action après l'effet de clic
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: _isTapped ? Colors.white.withOpacity(0.5) : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Text(
          widget.answer,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}