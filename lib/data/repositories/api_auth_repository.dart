import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voz_popular/data/models/user_model.dart';
import 'package:voz_popular/data/repositories/auth_repository.dart';
import 'package:voz_popular/data/services/api_client.dart';
import 'package:voz_popular/data/services/auth_manager.dart';

class ApiAuthRepository implements AuthRepository {
  final Dio _dio = ApiClient.instance.dio;

  @override
  Future<User> login({required String email, required String password}) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });
      
      if (response.statusCode == 200) {
        final data = response.data;
        final token = data['token'] as String?;
        
        final user = User.fromJson(data['user']); 

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
        }

        await AuthManager.instance.login(user);
        
        return User.fromJson(data['user']);
      } else {
        throw Exception('Falha ao fazer login.');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? 'Erro de conexão. Verifique sua internet.';
      throw Exception(errorMessage);
    }
  }

  @override
  Future<User> register({required String name, required String email, required String password}) async {
    try {
      final response = await _dio.post('/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });

      if (response.statusCode == 201) {
        final data = response.data;
        final token = data['token'] as String?;
        
        final user = User.fromJson(data['user']); 
        
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
        }

        await AuthManager.instance.login(user);

        return User.fromJson(data['user']);
      } else {
        throw Exception('Falha ao realizar o cadastro.');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? 'Erro de conexão.';
      throw Exception(errorMessage);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post('/logout');
    } finally {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      AuthManager.instance.logout();
    }
  }
}
