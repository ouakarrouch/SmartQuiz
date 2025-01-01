import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QuizPage extends StatefulWidget {
  final int timeLimit; // Limite de temps en secondes
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
  late int remainingTime; // Temps restant
  Timer? countdownTimer;
  String quizTitle = ""; // Titre du quiz récupéré depuis la base de données
  String questionText =
      ""; // Texte de la question récupéré depuis la base de données
  String answer1 = ""; // Réponse 1 récupérée depuis la base de données
  String answer2 = ""; // Réponse 2 récupérée depuis la base de données
  String answer3 = ""; // Réponse 3 récupérée depuis la base de données
  int currentQuestionIndex = 1; // Index de la question actuelle
  int totalQuestions = 0; // Nombre total de questions du quiz

  @override
  void initState() {
    super.initState();
    remainingTime = widget.timeLimit;
    fetchQuizTitle(); // Récupération du titre du quiz
    fetchTotalQuestions(); // Récupération du nombre total de questions
    fetchQuestion(); // Récupération de la question et des réponses
    startCountdown();
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

  Future<void> fetchTotalQuestions() async {
    try {
      // On récupère le nombre total de questions directement depuis la table 'quiz'
      final response = await Supabase.instance.client
          .from('quiz') // Table où se trouve la colonne 'number_of_questions'
          .select(
              'number_of_questions') // Sélectionner la colonne 'number_of_questions'
          .eq('quiz_code', widget.quizCode) // Filtrer par le code du quiz
          .maybeSingle(); // S'assurer qu'on obtient un seul résultat

      // Vérifier si la réponse est valide et que le nombre de questions existe
      if (response != null && response['number_of_questions'] != null) {
        setState(() {
          totalQuestions = response[
              'number_of_questions']; // Récupérer la valeur de 'number_of_questions'
        });
      } else {
        setState(() {
          totalQuestions = 0; // Si aucune donnée n'est trouvée
        });
      }
    } catch (e) {
      setState(() {
        totalQuestions =
            0; // Erreur lors de la récupération du nombre de questions
      });
    }
  }

  // Fonction pour récupérer la question et les réponses depuis la table `quiz_questions`
  Future<void> fetchQuestion() async {
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

        // Récupérer la question et les réponses à partir de 'quiz_questions'
        final response = await Supabase.instance.client
            .from('quiz_questions')
            .select('question_text, answer1, answer2, answer3')
            .eq('quiz_id',
                quizId) // Utiliser 'quiz_id' pour filtrer les questions
            .limit(1)
            .maybeSingle();

        if (response != null) {
          setState(() {
            questionText = response['question_text'] ?? "Question introuvable";
            answer1 = response['answer1'] ?? "Réponse 1 non trouvée";
            answer2 = response['answer2'] ?? "Réponse 2 non trouvée";
            answer3 = response['answer3'] ?? "Réponse 3 non trouvée";
          });
        } else {
          setState(() {
            questionText = "Question introuvable";
            answer1 = "Réponse 1 non trouvée";
            answer2 = "Réponse 2 non trouvée";
            answer3 = "Réponse 3 non trouvée";
          });
        }
      } else {
        setState(() {
          questionText = "Quiz non trouvé";
          answer1 = "Réponse 1 non trouvée";
          answer2 = "Réponse 2 non trouvée";
          answer3 = "Réponse 3 non trouvée";
        });
      }
    } catch (e) {
      setState(() {
        questionText = "Erreur lors de la récupération de la question";
        answer1 = "Erreur réponse 1";
        answer2 = "Erreur réponse 2";
        answer3 = "Erreur réponse 3";
      });
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
        // Action lorsque le temps est écoulé
        _showTimeUpDialog();
      }
    });
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Temps écoulé !'),
        content: const Text('Le temps imparti pour répondre est terminé.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Retour à la page précédente
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(quizTitle.isEmpty ? 'Chargement...' : quizTitle),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.lightBlueAccent,
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
                    '$currentQuestionIndex/$totalQuestions',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    child: Text(
                      formatTime(remainingTime),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  questionText.isEmpty
                      ? 'Chargement de la question...'
                      : questionText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Affichage des réponses
              Column(
                children: [
                  AnswerTile(answer: answer1),
                  AnswerTile(answer: answer2),
                  AnswerTile(answer: answer3),
                ],
              ),
              const SizedBox(height: 30),
              // Bouton suivant
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (currentQuestionIndex < totalQuestions) {
                      currentQuestionIndex++; // Passer à la question suivante
                    }
                  });
                  fetchQuestion(); // Récupérer la question suivante
                  countdownTimer?.cancel();
                  startCountdown(); // Redémarrer le chronomètre
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Suivant',
                  style: TextStyle(fontSize: 16, color: Colors.white),
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
class AnswerTile extends StatelessWidget {
  final String answer;

  const AnswerTile({Key? key, required this.answer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Text(
        answer,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );
  }
}
