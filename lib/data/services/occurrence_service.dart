import 'dart:io';
import 'dart:typed_data';
import 'package:voz_popular/data/models/occurrence_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class OccurrenceService {
  final String baseUrl = 'http://127.0.0.1:8000/';
  //retorna lista ocorrencia
  Future<List<Occurrence>> getOccurrences() async {
    await Future.delayed(const Duration(seconds: 2));

    return [
        //dados pré cadastrados
    ];
  }

  Future<void> submitOccurrence({
    required String title,
    required String description,
    required String street,
    required String number,
    required String neighbohood,
    required String categoryId,
    required String themeId,
    //required File imageFile,
    File? mobileImageFile,
    Uint8List? webImageBytes,
    required LatLng position,
  }) async {
    //tempo simulado
    print('Iniciando envio da ocorrência...');
    await Future.delayed(const Duration(seconds: 3));

    //validação imagem
    if (mobileImageFile == null && webImageBytes == null) {
      throw Exception('Nenhuma imagem fornecida para a ocorrência.');
    }

    //enviar no futuro para o laravel
    print('--- OCORRÊNCIA RECEBIDA PELO SERVIÇO ---');
    print('Título: $title');
    print('Descrição: $description');
    print('Categoria: $categoryId');
    if (mobileImageFile != null) {
      print('Enviado do mobile. Caminho: ${mobileImageFile.path}');
    }
    if (webImageBytes!= null) {
      print('Enviado da web. Tamanho da imagem: ${webImageBytes.length} bytes');
    }
    //print('Caminho da Imagem: ${imageFile.path}');
    print(
      'Localização: (Lat: ${position.latitude}, Lon: ${position.longitude})',
    );
    print('-----------------------------------------');
    print('Ocorrência enviada com sucesso!');
  }
}
