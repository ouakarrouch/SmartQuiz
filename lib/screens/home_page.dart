import 'package:flutter/material.dart';
import 'participer_quiz_page.dart'; // Import de la page "Participer à un Quiz"
import 'package:quiz/screens/CréerQuizPage.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB2E0F7), // Couleur bleu clair de fond
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Titre principal
            Text(
              "SMARTQUIZ",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.yellow[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            // Sous-titre
            Text(
              "Testez vos limites, enrichissez\nvos connaissances !",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Du fun, du savoir, un quiz pour tous !",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            // Boutons principaux
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigation vers la page de création de quiz
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateQuizPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 20,
                    ),
                  ),
                  child: const Text(
                    "Créer Quiz",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigation vers la page "Participer à un Quiz"
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ParticiperQuizPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 20,
                    ),
                  ),
                  child: const Text(
                    "Participer à un Quiz",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Liste des catégories
            Expanded(
              child: ListView(
                children: [
                  CategoryItem(
                    icon: Icons.history,
                    label: "Histoire",
                    color: Colors.blue[400],
                  ),
                  CategoryItem(
                    icon: Icons.public,
                    label: "Géographie",
                    color: Colors.blue[400],
                  ),
                  CategoryItem(
                    icon: Icons.science,
                    label: "Sciences",
                    color: Colors.blue[400],
                  ),
                  CategoryItem(
                    icon: Icons.music_note,
                    label: "Musique",
                    color: Colors.blue[400],
                  ),
                  CategoryItem(
                    icon: Icons.sports_basketball,
                    label: "Sport",
                    color: Colors.blue[400],
                  ),
                  CategoryItem(
                    icon: Icons.movie,
                    label: "Cinéma",
                    color: Colors.blue[400],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.black54,
        currentIndex: 0, // Définit la page active sur l'Accueil
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home'); // Page d'accueil
          } else if (index == 1) {
            Navigator.pushNamed(context, '/settings'); // Page paramètres
          } else if (index == 2) {
            Navigator.pushNamed(context, '/leaderboard'); // Page classement
          } else if (index == 3) {
            Navigator.pushNamed(context, '/profile'); // Page profil
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Paramètres",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: "Classement",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}

// Widget personnalisé pour les catégories
class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const CategoryItem({
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(
            icon,
            size: 30,
            color: Colors.white,
          ),
          title: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          onTap: () {
            // Action à effectuer lors d'un clic sur une catégorie
          },
        ),
      ),
    );
  }
}
