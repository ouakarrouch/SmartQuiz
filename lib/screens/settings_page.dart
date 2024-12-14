import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false; // Variable pour gérer le thème

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Paramètres",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Modifier Profil
            _buildListTile(Icons.person, 'Modifier Profil', () {
              Navigator.pushNamed(context, '/editProfile'); // Navigation vers la page Modifier Profil
            }),
            // Sécurité
            _buildListTile(Icons.lock, 'Sécurité', () {
              Navigator.pushNamed(context, '/security'); // Navigation vers la page Sécurité
            }),
            // Ajouter Compte
            _buildListTile(Icons.account_box, 'Ajouter Compte', () {
              Navigator.pushNamed(context, '/addAccount'); // Navigation vers la page Ajouter Compte
            }),
            // Mes Quizzes
            _buildListTile(Icons.quiz, 'Mes Quizzes', () {
              Navigator.pushNamed(context, '/myQuizzes'); // Navigation vers la page Mes Quizzes
            }),
            // Espacement
            const Divider(),
            // Thème
            ListTile(
              title: const Text('Thème'),
              trailing: Switch(
                value: _isDarkMode,
                onChanged: (value) {
                  setState(() {
                    _isDarkMode = value;
                  });
                },
              ),
            ),
            // Déconnexion
            _buildListTile(Icons.exit_to_app, 'Déconnexion', () {
              Navigator.pushReplacementNamed(context, '/logout'); // Redirection vers la page de déconnexion
            }),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.black54,
        currentIndex: 1, // Indique que "Paramètres" est sélectionné
        onTap: (index) {
          // Navigation vers les autres pages
          if (index == 0) Navigator.pushNamed(context, '/home');
          if (index == 2) Navigator.pushNamed(context, '/leaderboard');
          if (index == 3) Navigator.pushNamed(context, '/profile');
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

  // Widget pour une ligne de paramètres
  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      onTap: onTap,
    );
  }
}
