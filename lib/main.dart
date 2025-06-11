import 'package:flutter/material.dart';
import 'package:voz_popular/presentation/screens/login/login_screen.dart';
import 'package:voz_popular/presentation/screens/login/login_screen.dart';
import 'package:voz_popular/presentation/screens/register/register_screen.dart';
import 'package:voz_popular/presentation/screens/home/home_screen.dart';
import 'package:voz_popular/presentation/screens/profile/profile_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voz Popular',
      theme: ThemeData( // Seu tema continua aqui...
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        )
      ),
      // home: const LoginScreen(), // REMOVA ou COMENTE esta linha
      initialRoute: '/login', // Define a rota inicial
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
