import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final Dio dio;

  //singleton
  ApiClient._privateConstructor()
      : dio = Dio(BaseOptions(
          //url da api
          baseUrl: 'http://127.0.0.1:8000/api', 
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        )){

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            final prefs = await SharedPreferences.getInstance();
            final token = prefs.getString('auth_token');

            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
              print('Token adicionado ao cabeçalho: Bearer $token');
            } 
            return handler.next(options);
          },
          onError: (DioException e, handler) {
              if (e.response?.statusCode == 401) {
                print('Token inválido ou expirado. A fazer logout...');
                // AuthManager.instance.logout(); //futura implementação
              }
              return handler.next(e);
          }
      ),
    );
  }
  //singleton cliente
  static final ApiClient instance = ApiClient._privateConstructor();
}