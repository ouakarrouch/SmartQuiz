import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = 'Non défini';
  String email = 'Non défini';
  String phone = 'Non défini';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Charger les données depuis SharedPreferences
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedName = prefs.getString('name');
    String? savedEmail = prefs.getString('email');
    String? savedPhone = prefs.getString('phone');

    // Affichez les valeurs récupérées dans la console pour déboguer
    print("Loaded data: Name=$savedName, Email=$savedEmail, Phone=$savedPhone");

    setState(() {
      name = savedName ?? 'Non défini';
      email = savedEmail ?? 'Non défini';
      phone = savedPhone ?? 'Non défini';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB2E0F7), // Couleur de fond
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Mon Profil",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Image de profil
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/profile_picture.png"), // Remplacez par une image locale
              ),
              const SizedBox(height: 20),
              // Formulaire
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildTextField("Nom", name),
                    const SizedBox(height: 10),
                    _buildTextField("Email", email),
                    const SizedBox(height: 10),
                    _buildTextField("Téléphone", phone),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Statistiques (si vous en avez besoin)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatsBox("Points", "590"),
                  _buildStatsBox("Classement", "#56"),
                ],
              ),
              const SizedBox(height: 20),
              // Cartes de statistiques détaillées (si vous en avez besoin)
              _buildStatsCard(
                "Vous avez joué un total de",
                "24 quizzes",
                played: 21,
                total: 24,
                created: 5,
                won: 21,
              ),
              const SizedBox(height: 20),
              _buildStatsCard(
                "Vous avez joué un total de",
                "15 compétitions",
                played: 11,
                total: 15,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.black54,
        currentIndex: 3, // Indique que "Profil" est sélectionné
        onTap: (index) {
          // Navigation vers les autres pages
          if (index == 0) Navigator.pushNamed(context, '/home');
          if (index == 1) Navigator.pushNamed(context, '/settings');
          if (index == 2) Navigator.pushNamed(context, '/leaderboard');
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

  // Widget pour un champ texte
  Widget _buildTextField(String label, String value) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        hintText: value,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
      ),
      enabled: false, // Le champ est en lecture seule
    );
  }

  // Widget pour une boîte de statistiques
  Widget _buildStatsBox(String title, String value) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // Widget pour une carte de statistiques détaillées
  Widget _buildStatsCard(String title, String subtitle,
      {required int played, required int total, int? created, int? won}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          const SizedBox(height: 10),
          // Progression circulaire
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCircularProgress(played, total, "Quiz joué"),
              if (created != null) _buildStatsColumn(created, "Quiz Créé"),
              if (won != null) _buildStatsColumn(won, "Quiz Gagné"),
            ],
          ),
        ],
      ),
    );
  }

  // Widget pour une colonne de statistiques
  Widget _buildStatsColumn(int value, String label) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }

  // Widget pour une progression circulaire
  Widget _buildCircularProgress(int played, int total, String label) {
    return Column(
      children: [
        SizedBox(
          height: 80,
          width: 80,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: played / total,
                strokeWidth: 8,
                backgroundColor: Colors.purple[100],
                valueColor: AlwaysStoppedAnimation(Colors.purple),
              ),
              Center(
                child: Text(
                  "$played/$total",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }
}
