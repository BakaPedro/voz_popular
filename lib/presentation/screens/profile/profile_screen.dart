import 'package:flutter/material.dart';
import 'package:voz_popular/data/repositories/auth_repository.dart';
import 'package:voz_popular/data/services/auth_manager.dart';
import 'package:voz_popular/locator.dart';
import 'package:voz_popular/routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      final authRepository = locator<AuthRepository>();
      await authRepository.logout();
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
    // Obtém o utilizador logado diretamente do AuthManager
    final user = AuthManager.instance.currentUser;

    // Usa os dados do utilizador real, com um valor de fallback caso seja nulo
    final userName = user?.name ?? 'xxxxx';
    final userEmail = user?.email ?? 'xxxxx';

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            iconSize: 35,
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Notificações',
            onPressed: () {
              print('Sino de notificação clicado');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          ClipPath(
            clipper: HalfCircleClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              color: const Color.fromARGB(255, 69, 61, 87),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  const CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 60, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userName, // Exibe o nome real
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SpoofTrial',
                          color: Colors.white
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userEmail, // Exibe o e-mail real
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: const Color.fromARGB(255, 255, 255, 255)),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.logout),
                      label: const Text('Sair'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.withOpacity(0.1),
                        foregroundColor: Colors.red.shade800,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.red.shade200),
                        ),
                      ),
                      onPressed: () => _logout(context),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
