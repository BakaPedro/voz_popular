import 'package:flutter/material.dart';
import 'package:voz_popular/data/repositories/auth_repository.dart';
import 'package:voz_popular/locator.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  //logout
  Future<void> _logout(BuildContext context) async {
    try {
      //final authService = AuthService();
      final authRepository = locator<AuthRepository>();
      await authRepository.logout();
      //await Future.delayed(Duration.zero);
      //volta pro login
      /*if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.login,
          (Route<dynamic> route) => false, //remoção de rotas
        );
      }*/
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao fazer logout: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //dados pré-cadastrados
    const userName = 'Usuário Teste';
    const userEmail = 'teste@exemplo.com';

    return Scaffold(
      appBar: AppBar(title: const Text('Meu Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 16),
            Text(userName, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(userEmail, style: Theme.of(context).textTheme.bodyLarge),
            const Spacer(), //ocupar espaço vertical
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Sair'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => _logout(context),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
