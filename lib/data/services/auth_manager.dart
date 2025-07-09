import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voz_popular/data/models/user_model.dart';

class AuthManager {
  AuthManager._privateConstructor();
  static final AuthManager instance = AuthManager._privateConstructor();

  //notifica sempre que muda o estado
  final ValueNotifier<bool> isLoggedInNotifier = ValueNotifier(false);

  User? currentUser;  

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

   if (isLoggedIn) {
      final userDataString = prefs.getString('user_data');
      if (userDataString != null) {
        currentUser = User.fromJson(jsonDecode(userDataString));
      }
    }

    isLoggedInNotifier.value = isLoggedIn;
    print('[AuthManager] Estado de login inicializado como: $isLoggedIn');
  }

  bool get isLoggedIn => isLoggedInNotifier.value;

//alertar

  Future<void> login(User user) async {
    currentUser = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('user_data', jsonEncode(user.toJson()));
    isLoggedInNotifier.value = true;
  }
  Future<void> logout() async {
    currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('isLoggedIn');
    await prefs.remove('user_data');
    isLoggedInNotifier.value = false;
  }
}