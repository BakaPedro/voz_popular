import 'package:flutter/material.dart';
import 'package:voz_popular/presentation/screens/home/home_screen.dart';
import 'package:voz_popular/presentation/screens/login/login_screen.dart';
import 'package:voz_popular/presentation/screens/new_occurrence/new_occurrence_screen.dart';
import 'package:voz_popular/presentation/screens/profile/profile_screen.dart';
import 'package:voz_popular/presentation/screens/register/register_screen.dart';

class AppRoutes {
  //constantes
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String newOccurrence = '/new-occurrence';
  static const String profile = '/profile';

  //retorna a rota do mapeamento
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      home: (context) => const HomeScreen(),
      newOccurrence: (context) => const NewOccurrenceScreen(),
      profile: (context) => const ProfileScreen(),
    };
  }
}