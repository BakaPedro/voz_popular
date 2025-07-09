/*import 'package:voz_popular/data/models/user_model.dart';
import 'package:voz_popular/data/services/auth_manager.dart';

class AuthService {
  
  Future<User> login(String email, String password) async {
    //simulação 2 segundos
    await Future.delayed(const Duration(seconds: 2));
    //simulação verificação
    if (email == 'teste@exemplo.com' && password == '1') {
      AuthManager.instance.login();
      return User(id: '1', name: 'Usuário Teste', email: email);
    } else {
      throw Exception('E-mail ou senha inválidos');
    }
  }

  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {

    await Future.delayed(const Duration(seconds: 2));

    if (email == 'existente@exemplo.com') {
      throw Exception('Este e-mail já está em uso.');
    }

    print('Usuário cadastrado com sucesso: $name');
    return User(id: '2', name: name, email: email);
  }
  
  Future<void> logout() async {
  //simula invalidação
  await Future.delayed(const Duration(milliseconds: 500));
  AuthManager.instance.logout();
  print('Usuário deslogado com sucesso!');
}
}*/