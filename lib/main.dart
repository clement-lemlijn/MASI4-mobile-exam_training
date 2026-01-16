import 'package:flutter/material.dart';
import 'screens/task_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YouList',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const TaskListScreen(),
      routes: {
        // si tu as un écran "à propos", tu peux l'ajouter ici
        // '/about': (context) => const AboutScreen(),
      },
    );
  }
}
