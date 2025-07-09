import 'package:flutter/material.dart';

//telas
import 'package:voz_popular/presentation/screens/home/home_screen.dart';
import 'package:voz_popular/presentation/screens/login/login_screen.dart';
import 'package:voz_popular/presentation/screens/new_occurrence/new_occurrence_screen_old.dart';
import 'package:voz_popular/presentation/screens/profile/profile_screen.dart';
import 'package:voz_popular/presentation/screens/register/register_screen.dart';
import 'package:voz_popular/presentation/screens/welcome/welcome_screen.dart';
import 'package:voz_popular/presentation/screens/occurrence_details/occurrence_details_screen.dart';

class AppRoutes {
  //constantes
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String newOccurrence = '/new-occurrence';
  static const String profile = '/profile';
  static const String occurrenceDetails = '/occurrence-details';

  //retorna mapeamento das rotas
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      welcome: (context) => const WelcomeScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      home: (context) => const HomeScreen(),
      newOccurrence: (context) => const NewOccurrenceScreen(),
      profile: (context) => const ProfileScreen(),
    };
  }

  //proteção das rotas
  /*static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final protectedRoutes = [home, profile, newOccurrence];
    final isUserLoggedIn = AuthManager.instance.isLoggedIn;
    final isNavigatingToProtectedRoute = protectedRoutes.contains(
      settings.name,
    );

    if (!isUserLoggedIn && isNavigatingToProtectedRoute) {
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
        settings: const RouteSettings(name: login),
      );
    }

    final routesMap = getRoutes();
    final builder = routesMap[settings.name];

    if (builder != null) {
      return MaterialPageRoute(builder: builder, settings: settings);
    }

    //rota padrão se não der certo
    return MaterialPageRoute(
      builder: (context) => const LoginScreen(),
      settings: const RouteSettings(name: login),
    );
  }*/

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {

    if (settings.name == occurrenceDetails) {
      if (settings.arguments is String) {
        final String occurrenceId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => OccurrenceDetailsScreen(occurrenceId: occurrenceId),
        );
      }
      return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Erro: ID da ocorrência inválido.'))));
    }

    final routesMap = getRoutes();
    final builder = routesMap[settings.name];

    if (builder != null) {
      return MaterialPageRoute(builder: builder, settings: settings);
    }

    return MaterialPageRoute(
      builder: (context) => const LoginScreen(),
      settings: const RouteSettings(name: login),
    );
  }

}
