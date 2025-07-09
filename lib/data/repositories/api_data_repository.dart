import 'package:dio/dio.dart';
import 'package:voz_popular/data/models/category_model.dart';
import 'package:voz_popular/data/models/theme_model.dart';
import 'package:voz_popular/data/repositories/data_repository.dart';
import 'package:voz_popular/data/services/api_client.dart';

class ApiDataRepository implements DataRepository {
  final Dio _dio = ApiClient.instance.dio;

  @override
  Future<List<Category>> getCategories() async {
    try {
      final response = await _dio.get('/categorias');
      final List<dynamic> data = response.data;
      return data.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      print('Erro ao buscar categorias: $e');
      throw Exception('Não foi possível carregar as categorias.');
    }
  }

  @override
  Future<List<ThemeModel>> getThemes() async {
    try {
      final response = await _dio.get('/temas');
      final List<dynamic> data = response.data;
      return data.map((json) => ThemeModel.fromJson(json)).toList();
    } catch (e) {
      print('Erro ao buscar temas: $e');
      throw Exception('Não foi possível carregar os temas.');
    }
  }
}
