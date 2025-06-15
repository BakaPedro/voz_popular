import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  //singleton
  ApiClient._privateConstructor()
      : dio = Dio(BaseOptions(
          //url da api
          baseUrl: 'http://api-teste/api', 
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ));

  //singleton cliente
  static final ApiClient instance = ApiClient._privateConstructor();
}