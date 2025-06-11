import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Início'),
      ),
      body: const Center(
        child: Text(
          'Esta é a Tela de Início (Home)',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}