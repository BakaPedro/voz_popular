import 'package:voz_popular/data/models/user_model.dart';

class AuthService {
  
  Future<User> login(String email, String password) async {
    //simulação 2 segundos
    await Future.delayed(const Duration(seconds: 2));
    //simulação verificação
    if (email == 'teste@exemplo.com' && password == '123456') {
      return User(id: '1', name: 'Usuário Teste', email: email);
    } else {
      throw Exception('E-mail ou senha inválidos');
    }
  }
}