import 'dart:io';
import 'dart:typed_data';
import 'package:voz_popular/data/models/occurrence_model.dart';
import 'package:geolocator/geolocator.dart';


class OccurrenceService {
  final String baseUrl = 'http://127.0.0.1:8000/';
  //retorna lista ocorrencia
  Future<List<Occurrence>> getOccurrences() async {
    await Future.delayed(const Duration(seconds: 2));

    //dados pré cadastrados
    return [
      Occurrence(
        id: '1',
        title: 'Buraco na rua',
        description: 'Um buraco que causa transtorno aos cidadãos',
        address: 'Rua Major Gama, 123',
        status: OccurrenceStatus.resolvido,
        imageUrl:
            'https://png.pngtree.com/thumb_back/fh260/background/20230610/pngtree-large-hole-in-the-middle-of-a-street-surrounded-by-people-image_2934306.jpg',
      ),
      Occurrence(
        id: '2',
        title: 'Lâmpada de poste queimada',
        description:
            'O poste em frente ao mercado 2 irmãos queimou tem 3 semanas',
        address: 'Mercado 2 irmãos, 13',
        status: OccurrenceStatus.emAndamento,
        imageUrl:
            'https://cdn.cgn.inf.br/fotos-cgn/2019/11/05051658/WhatsApp-Image-2019-11-05-at-05.09.25.jpeg',
      ),
      Occurrence(
        id: '3',
        title: 'Lixo acumulado na esquina',
        description:
            'Há um grande acúmulo de lixo na esquina da Rua da Alegria',
        address: 'Rua da Alegria, 456',
        status: OccurrenceStatus.recebido,
        imageUrl:
            'https://imagens.ebc.com.br/VSF6jSi1SAwgA1iHrpzDMUQkK6g=/1170x700/smart/https://agenciabrasil.ebc.com.br/sites/default/files/thumbnails/image/ffraz_abr_26041914830.jpg?itok=BtbweCG2',
      ),
    ];
  }

  Future<void> submitOccurrence({
    required String title,
    required String description,
    required String category,
    //required File imageFile,
    required String address,
    File? mobileImageFile,
    Uint8List? webImageBytes,
    required Position position,
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
    print('Categoria: $category');
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
