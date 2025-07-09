import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:voz_popular/data/models/comment_model.dart';
import 'package:voz_popular/data/models/occurrence_model.dart';
import 'package:voz_popular/data/repositories/auth_repository.dart';
import 'package:voz_popular/data/services/api_client.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:latlong2/latlong.dart';

//api laravel
class ApiOccurrenceRepository implements OccurrenceRepository {
  final Dio _dio = ApiClient.instance.dio;

  @override
  Future<List<Occurrence>> getMyOccurrences() async {
    try {
      final response = await _dio.get('/minhas-ocorrencias');


      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
              for (var json in data) {
        print('JSON recebido de /minhas-ocorrencias: $json');
      }      
      
        return data.map((json) => Occurrence.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar as suas ocorrências');
      }
    } on DioException catch (e) {
      print('Erro em getMyOccurrences: $e');
      throw Exception('Não foi possível conectar ao servidor. Verifique a sua conexão.');
    } catch (e) {
      print('Erro inesperado em getMyOccurrences: $e');
      throw Exception('Ocorreu um erro inesperado.');
    }
  }
  @override
  Future<List<Occurrence>> getOccurrences({OccurrenceStatus? status}) async {
    try {
      final params = <String, dynamic>{};
      if (status != null) {
        String statusString;
        switch (status) {
          case OccurrenceStatus.em_andamento:
            statusString = 'em_andamento';
            break;
          case OccurrenceStatus.em_analise:
            statusString = 'em_analise';
            break;
          case OccurrenceStatus.concluido:
            statusString = 'concluido';
            break;
          case OccurrenceStatus.atrasado:
            statusString = 'atrasado';
            break;
          case OccurrenceStatus.recebido:
            statusString = 'recebido';
            break;
        }
        params['status'] = statusString;
      }
      final response = await _dio.get('/ocorrencias', queryParameters: params);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Occurrence.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar ocorrências');
      }
    } on DioException catch (e) {
      print('Erro em getOccurrences: $e');
      throw Exception(
        'Não foi possível conectar ao servidor. Verifique sua conexão.',
      );
    } catch (e) {
      print('Erro inesperado em getOccurrences: $e');
      throw Exception('Ocorreu um erro inesperado.');
    }
  }
  @override
  Future<Occurrence> getOccurrenceDetails(String id) async {
    try {
      final response = await _dio.get('/ocorrencias/$id');

      if (response.statusCode == 200) {
        return Occurrence.fromJson(response.data);
      } else {
        throw Exception('Falha ao carregar os detalhes da ocorrência');
      }
    } on DioException catch (e) {
      print('Erro em getOccurrenceDetails: $e');
      throw Exception('Não foi possível conectar ao servidor.');
    } catch (e) {
      print('Erro inesperado em getOccurrenceDetails: $e');
      throw Exception('Ocorreu um erro inesperado.');
    }
  }
  
  //auth_repository.dart
  @override
  Future<void> submitOccurrence({
    required String description,
    required String street,
    required String number,
    required String neighborhood,
    required String reference,
    required String categoryId,
    required String themeId,
    File? mobileImageFile,
    Uint8List? webImageBytes,
    required LatLng position,
  }) async {
    try {

      final Map<String, dynamic> dataMap = {
        'descricao': description,
        'rua': street,
        'numero': number,
        'bairro': neighborhood,
        'referencia': reference,
        'categoria_id': categoryId,
        'tema_id': themeId,
        'latitude': position.latitude,
        'longitude': position.longitude,
      };

      if (!kIsWeb && mobileImageFile != null) {
        final mimeType = lookupMimeType(mobileImageFile.path);
        dataMap['imagem'] = await MultipartFile.fromFile(
          mobileImageFile.path,
          filename: mobileImageFile.path.split('/').last,
          contentType: mimeType != null ? MediaType.parse(mimeType) : null,
        );
      } else if (kIsWeb && webImageBytes != null) {
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
        // options: Options(
        //   headers: {
        //     //o dio define o Content-Type para 'multipart/form-data ao enviar um FormData
        //   },
        // ),
      );
    } on DioException catch (e) {
      print('Erro em submitOccurrence: ${e.response?.data ?? e.message}');
      throw Exception(
        'Falha ao enviar ocorrência. Verifique os dados e tente novamente.',
      );
    } catch (e) {
      print('Erro inesperado em submitOccurrence: $e');
      throw Exception('Ocorreu um erro inesperado.');
    }
  }
  
  @override
  Future<List<Comment>> getComments(String occurrenceId) async {
    try {
      final response = await _dio.get('/ocorrencias/$occurrenceId/comentarios');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Comment.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar comentários.');
      }
    } on DioException catch (e) {
      print('Erro ao buscar comentários: $e');
      throw Exception('Não foi possível carregar os comentários.');
    }
  }
}
