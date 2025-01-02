import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String lastName = '';
  String firstName = '';
  String email = '';
  String phone = '';
  int score = 0; // Variable pour stocker le score
  String? photoUrl; // Variable pour stocker l'URL de la photo

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId != null) {
        final response = await Supabase.instance.client
            .from('users')
            .select('last_name, first_name, email, phone, score, photo') // Ajouter 'photo'
            .eq('id', userId)
            .single();

        if (response != null) {
          setState(() {
            lastName = response['last_name'] ?? '';
            firstName = response['first_name'] ?? '';
            email = response['email'] ?? '';
            phone = response['phone'] ?? '';
            score = response['score'] ?? 0; // Récupérer le score
            photoUrl = response['photo']; // Récupérer l'URL de la photo
          });
        }
      }
    } catch (e) {
      print('Erreur lors de la récupération des informations de l\'utilisateur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mon Profil',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Centrer horizontalement
            children: [
              // Photo de l'utilisateur
              if (photoUrl != null)
                CircleAvatar(
                  backgroundImage: NetworkImage(photoUrl!),
                  radius: 50,
                )
              else
                const CircleAvatar(
                  child: Icon(Icons.person, size: 50),
                  radius: 50,
                ),
              const SizedBox(height: 20), // Espacement

              // Section des informations personnelles
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informations Personnelles',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4E55A1),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow('Nom', lastName),
                      const SizedBox(height: 12),
                      _buildInfoRow('Prénom', firstName),
                      const SizedBox(height: 12),
                      _buildInfoRow('E-mail', email),
                      const SizedBox(height: 12),
                      _buildInfoRow('Téléphone', phone),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Section des points et classement
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'POINTS',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF4E55A1),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$score', // Afficher le score dynamique
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'CLASSEMENT',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF4E55A1),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '#56',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pour afficher une ligne d'information
  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label : ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}