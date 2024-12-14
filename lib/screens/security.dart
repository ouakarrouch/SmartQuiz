import 'package:flutter/material.dart';

class SecurityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sécurité"),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            leading: Icon(Icons.lock_outline, color: Colors.blue),
            title: Text("Changer le mot de passe"),
            onTap: () {
              // Ajouter ici la logique pour changer le mot de passe
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.security, color: Colors.blue),
            title: Text("Activer la vérification en deux étapes"),
            onTap: () {
              // Ajouter ici la logique pour activer la 2FA
            },
          ),
        ],
      ),
    );
  }
}
