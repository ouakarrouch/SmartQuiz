import 'package:flutter/material.dart';

class LeaderboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Classement"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Voici le classement des meilleurs joueurs !",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // Ajouter des données de classement ici
            // Par exemple, une liste d'utilisateurs avec leurs scores
            Expanded(
              child: ListView(
                children: [
                  _buildLeaderboardItem("Player 1", 100),
                  _buildLeaderboardItem("Player 2", 90),
                  _buildLeaderboardItem("Player 3", 80),
                  // Ajoutez d'autres joueurs ici
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
        currentIndex: 2, // Définit la page active sur Classement
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home'); // Accueil
          } else if (index == 1) {
            Navigator.pushNamed(context, '/settings'); // Paramètres
          } else if (index == 2) {
            // Classement, on reste sur la page actuelle
          } else if (index == 3) {
            Navigator.pushNamed(context, '/profile'); // Profil
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

  // Widget pour afficher un joueur et son score
  Widget _buildLeaderboardItem(String playerName, int score) {
    return ListTile(
      title: Text(playerName),
      subtitle: Text("Score: $score"),
      leading: Icon(Icons.star, color: Colors.yellow),
    );
  }
}
