import 'package:voz_popular/data/models/user_model.dart';
import 'package:voz_popular/data/repositories/auth_repository.dart';
import 'package:voz_popular/data/services/auth_manager.dart';

//mock = falso - não existe

class MockAuthRepository implements AuthRepository {
  @override
  Future<User> login({required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 2));
    if (email == 'teste@exemplo.com' && password == '1') {
      AuthManager.instance.login();
      return User(id: '1', name: 'Usuário Mockado', email: email);
    } else {
      throw Exception('E-mail ou senha inválidos');
    }
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    AuthManager.instance.logout();
    print('Usuário deslogado (Mock)');
  }

  @override
  Future<User> register({required String name, required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 2));
    if (email == 'existente@exemplo.com') {
      throw Exception('Este e-mail já está em uso.');
    }
    return User(id: '2', name: name, email: email);
  }
}