import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
      ),
      body: const Center(
        child: Text(
          'Esta é a Tela de Perfil',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}