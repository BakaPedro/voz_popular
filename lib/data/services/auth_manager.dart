import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  AuthManager._privateConstructor();
  static final AuthManager instance = AuthManager._privateConstructor();

  //notifica sempre que muda o estado
  final ValueNotifier<bool> isLoggedInNotifier = ValueNotifier(false);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    //lê valor. se n false
    isLoggedInNotifier.value = prefs.getBool('isLoggedIn') ?? false;
    print('[AuthManager] Estado de login inicializado como: ${isLoggedInNotifier.value}');
  }

  bool get isLoggedIn => isLoggedInNotifier.value;

//alertar

  Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();
    //salvar estado do login
    await prefs.setBool('isLoggedIn', true);
    isLoggedInNotifier.value = true;
  }
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    //remove estado
    await prefs.remove('isLoggedIn');
    isLoggedInNotifier.value = false;
  }
}