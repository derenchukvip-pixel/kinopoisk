import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Kinopoisk App')),
      body: const Center(
        child: Text(
          'Привет! Проект запущен 🎬',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}