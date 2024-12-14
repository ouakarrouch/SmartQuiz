import 'package:flutter/material.dart';

class MyQuizzesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes Quiz"),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            title: Text("Quiz 1: Histoire"),
            subtitle: Text("Terminé"),
            onTap: () {
              // Ouvrir le détail du quiz
            },
          ),
          Divider(),
          ListTile(
            title: Text("Quiz 2: Géographie"),
            subtitle: Text("En cours"),
            onTap: () {
              // Ouvrir le détail du quiz
            },
          ),
        ],
      ),
    );
  }
}
