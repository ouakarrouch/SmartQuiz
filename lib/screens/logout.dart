import 'package:flutter/material.dart';

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Logique pour déconnecter l'utilisateur
    // Vous pouvez appeler un service d'authentification pour supprimer les données de l'utilisateur, par exemple.

    return Scaffold(
      appBar: AppBar(
        title: Text("Déconnexion"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.exit_to_app, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              "Vous êtes maintenant déconnecté.",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Rediriger vers la page de connexion ou la page d'accueil
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text("Retour à la connexion"),
            ),
          ],
        ),
      ),
    );
  }
}
