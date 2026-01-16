import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text("À propos")),
    body: Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "Application de liste de tâches.\n\n"
              "Permet de gérer vos tâches avec :\n"
              " - priorité,\n"
              " - date,\n"
              " - note.\n\n"
              "Développée en Flutter par des dieux du code.\n\n"
              "Totalement réaliste, pas du tout pour un examen.",
          textAlign: TextAlign.left,
        ),
      ),
    ),
  );
}