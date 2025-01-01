import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:quiz/screens/Quizreadypage.dart';
import 'package:quiz/screens/Quizpage.dart';

class ParticiperQuizPage extends StatefulWidget {
  const ParticiperQuizPage({super.key});

  @override
  _ParticiperQuizPageState createState() => _ParticiperQuizPageState();
}

class _ParticiperQuizPageState extends State<ParticiperQuizPage> {
  final List<TextEditingController> _digitControllers =
      List.generate(4, (_) => TextEditingController());
  String _feedbackMessage = "";

  // Fonction pour vérifier si le code du quiz existe dans la base de données Supabase
  Future<void> _checkQuizCode() async {
    String code =
        _digitControllers.map((controller) => controller.text.trim()).join();

    if (code.length != 4) {
      setState(() {
        _feedbackMessage = "Veuillez entrer un code à 4 chiffres.";
      });
      return;
    }

    try {
      final quizResponse = await Supabase.instance.client
          .from('quiz') // Table 'quiz'
          .select('id, theme, difficulty, is_private, quiz_code, time_limit')
          .eq('quiz_code', code)
          .limit(1)
          .maybeSingle();

      if (quizResponse == null) {
        setState(() {
          _feedbackMessage = "Code incorrect ou quiz introuvable.";
        });
        return;
      }

      final theme = quizResponse['theme'] ?? "Quiz";
      final quizCode = quizResponse['quiz_code'] ?? code;
      final timeLimit = quizResponse['time_limit'] ?? 300; // Limite de temps en secondes

      // Naviguer vers QuizReadyPage en passant les données nécessaires
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizReadyPage(
            theme: theme, // Passe le thème du quiz
            quizCode: quizCode, // Passe le code du quiz
            timeLimit: timeLimit, // Passe la limite de temps
            onReady: () {
              // Navigue vers la page principale du quiz
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizPage(
                    theme: theme,
                    quizCode: quizCode,
                    timeLimit: timeLimit,
                  ),
                ),
              );
            },
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _feedbackMessage =
            "Erreur lors de la connexion à la base de données: $e";
      });
    }
  }

  @override
  void dispose() {
    // Dispose controllers when the widget est détruite
    for (var controller in _digitControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Participer à un Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Confiance en toi, tu es prêt !",
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 50,
                  child: TextField(
                    controller: _digitControllers[index],
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (value.length == 1 && index < 3) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkQuizCode,
              child: const Text("Participer"),
            ),
            const SizedBox(height: 20),
            Text(
              _feedbackMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
