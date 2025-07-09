import 'package:flutter/material.dart';
import 'package:voz_popular/locator.dart';
import 'package:voz_popular/presentation/screens/home/home_screen.dart';
//import 'package:voz_popular/presentation/screens/login/login_screen.dart';
import 'package:voz_popular/routes/app_routes.dart';
import 'package:voz_popular/data/services/auth_manager.dart';
import 'package:voz_popular/presentation/screens/welcome/welcome_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  //garante que esteja pronto
  WidgetsFlutterBinding.ensureInitialized();

  //inicializar dados
  await initializeDateFormatting('pt_BR', null);

  //inicializa o authmanager afim de carregar estado salvo
  await AuthManager.instance.init();
  setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
       valueListenable: AuthManager.instance.isLoggedInNotifier,
       builder: (context, isLoggedIn, child) {
        return MaterialApp(
          key: ValueKey(isLoggedIn),
          title: 'Voz Popular',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
          ),
          
          home: isLoggedIn ? const HomeScreen() : const WelcomeScreen(),
          
          onGenerateRoute: AppRoutes.onGenerateRoute,
        );
      },
    );
  }
}
