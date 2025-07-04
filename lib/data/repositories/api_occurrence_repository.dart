import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:voz_popular/data/models/occurrence_model.dart';
import 'package:voz_popular/data/repositories/auth_repository.dart';
import 'package:voz_popular/data/services/api_client.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart'; 

//api laravel
class ApiOccurrenceRepository implements OccurrenceRepository {
  final Dio _dio = ApiClient.instance.dio;

  @override
  Future<List<Occurrence>> getOccurrences() async {
    try {
      final response = await _dio.get('/ocorrencias');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Occurrence.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar ocorrências');
      }
    } on DioException catch (e) {
      print('Erro em getOccurrences: $e');
      throw Exception('Não foi possível conectar ao servidor. Verifique sua conexão.');
    } catch (e) {
      print('Erro inesperado em getOccurrences: $e');
      throw Exception('Ocorreu um erro inesperado.');
    }
  }

  //auth_repository.dart
  @override
  Future<void> submitOccurrence({
    required String title,
    required String description,
    required String address,
    required String category,
    File? mobileImageFile,
    Uint8List? webImageBytes,
    required Position position,
  }) async {
    try {
      final Map<String, dynamic> dataMap = {
        'titulo': title,
        'descricao': description,
        'localizacao': address,
        'categoria_id': category, //id?
        'latitude': position.latitude,
        'longitude': position.longitude,
        'status': 'recebido',
      };

      if (mobileImageFile != null) {
        final mimeType = lookupMimeType(mobileImageFile.path);
        dataMap['imagem'] = await MultipartFile.fromFile(
          mobileImageFile.path,
          filename: mobileImageFile.path.split('/').last,
          contentType: mimeType != null ? MediaType.parse(mimeType) : null,
        );
      } else if (webImageBytes != null) {
        dataMap['imagem'] = MultipartFile.fromBytes(
          webImageBytes,
          filename: 'upload.jpg',
          contentType: MediaType('image', 'jpeg'),
        );
      }

      final formData = FormData.fromMap(dataMap);

      await _dio.post(
        '/ocorrencias',
        data: formData,
        options: Options(
          headers: {
            // o dio define o Content-Type para 'multipart/form-data ao enviar um FormData
          },
        ),
      );
    } on DioException catch (e) {
      print('Erro em submitOccurrence: ${e.response?.data ?? e.message}');
      throw Exception('Falha ao enviar ocorrência. Verifique os dados e tente novamente.');
    } catch (e) {
      print('Erro inesperado em submitOccurrence: $e');
      throw Exception('Ocorreu um erro inesperado.');
    }
  }
}
