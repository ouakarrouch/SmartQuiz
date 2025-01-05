import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:quiz/screens/Quizpage.dart'; // Assurez-vous que le chemin est correct

class QuizSelectionPage extends StatefulWidget {
  final String theme;

  QuizSelectionPage({required this.theme});

  @override
  _QuizSelectionPageState createState() => _QuizSelectionPageState();
}

class _QuizSelectionPageState extends State<QuizSelectionPage> {
  late Future<List<Map<String, dynamic>>> futureQuizzes;
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    print('Thème sélectionné: ${widget.theme}'); // Log pour vérifier le thème
    futureQuizzes = fetchQuizzesByTheme(widget.theme);
  }

  Future<List<Map<String, dynamic>>> fetchQuizzesByTheme(String theme) async {
    try {
      // Récupérer les quiz publics pour le thème sélectionné
      final List<Map<String, dynamic>> response = await supabase
          .from('quiz') // Nom de la table
          .select()
          .eq('theme', theme) // Filtrer par thème
          .eq('is_private', false); // Récupérer uniquement les quiz publics

      print('Réponse de Supabase: $response'); // Log pour déboguer

      // Vérifier si la réponse est vide
      if (response.isEmpty) {
        throw Exception('Aucun quiz trouvé pour ce thème.');
      }

      return response; // Pas besoin de cast
    } on PostgrestException catch (e) {
      // Gestion des erreurs spécifiques à Supabase
      print('Erreur Supabase: ${e.message}');
      throw Exception('Erreur Supabase: ${e.message}');
    } catch (e) {
      // Gestion des erreurs générales
      print('Erreur inattendue: $e');
      throw Exception('Erreur inattendue: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.theme,
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: futureQuizzes,
            builder: (context, snapshot) {
              // Gestion des états de la Future
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Erreur: ${snapshot.error}',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'Aucun quiz disponible pour ce thème.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else {
                final quizzes = snapshot.data!;
                return ListView.builder(
                  itemCount: quizzes.length,
                  itemBuilder: (context, index) {
                    final quiz = quizzes[index];

                    // Gérer les valeurs null
                    final String quizId = quiz['id']?.toString() ?? 'ID_INCONNU'; // Convertir en chaîne
                    final String quizName = quiz['name'] ?? 'Quiz $quizId'; // Utiliser l'ID si le nom est null

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(
                          quizName, // Utiliser le nom ou l'ID si le nom est null
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF4E55A1),
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: const Color(0xFF4E55A1),
                        ),
                        onTap: () async {
                          try {
                            // Naviguer vers QuizPage avec les détails du quiz
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizPage(
                                  timeLimit: quiz['time_limit'] ?? 30, // Temps limite
                                  theme: quiz['theme'] ?? "Thème inconnu", // Thème du quiz
                                  quizCode: quiz['quiz_code'] ?? "CODE_INCONNU", // Code du quiz
                                  quizId: quizId, // Passer l'ID du quiz
                                ),
                              ),
                            );
                          } catch (e) {
                            // Gérer les erreurs
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Erreur: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}