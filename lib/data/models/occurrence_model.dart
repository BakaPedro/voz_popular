import 'package:intl/intl.dart';
import 'package:voz_popular/data/models/comment_model.dart';

//define status possiveis
enum OccurrenceStatus { recebido, em_analise, em_andamento, concluido, atrasado }

class Occurrence {
  final String id;
  final String title;
  final String description;
  final OccurrenceStatus status;
  final String imageUrl;
  final DateTime date;
  final String categoryName;
  final String themeName;
  final String street;
  final String number;
  final String neighborhood;
  final String reference;
  final String userName;
  final List<Comment> comments;
  final double latitude;
  final double longitude;
  final bool isOwner;
  String get formattedAddress {
    final parts = [street, number, neighborhood];
    parts.removeWhere((part) => part.isEmpty);
    return parts.join(', ');
  }
  Occurrence({
    required this.id,
    required this.title,
    required this.description,
    required this.street,
    required this.number,
    required this.neighborhood,
    required this.reference,
    required this.status,
    required this.imageUrl,
    required this.date,
    required this.categoryName,
    required this.themeName,
    required this.userName,
    required this.comments,
    required this.latitude,
    required this.longitude,
    required this.isOwner,
  });

  factory Occurrence.fromJson(Map<String, dynamic> json) {
    //converte a string do status para enum
    final statusString = json['status'] as String? ?? 'recebido';
    final status = OccurrenceStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == statusString.toLowerCase(),
      orElse: () => OccurrenceStatus.recebido,
    );

    final String imagePath = json['imagem'] ?? '';
    late final String fullImageUrl;
    if (imagePath.startsWith('http')) {
      fullImageUrl = imagePath;
    } else if (imagePath.isNotEmpty) {
      final String baseUrl = 'http://127.0.0.1:8000/api';
      final String filename = imagePath.split('/').last;
      fullImageUrl = '$baseUrl/images/$filename';
    } else {
      fullImageUrl = '';
    }

    var commentsList = json['comentarios'] as List? ?? [];
    List<Comment> parsedComments = commentsList.map((c) => Comment.fromJson(c)).toList();

    return Occurrence(
      id: json['id'].toString(),
      title: json['titulo'] ?? 'Título não informado',
      status: status,
      description: json['descricao'] ?? 'Sem descrição',
      street: json['rua'] ?? 'Sem informação',
      number: json['numero'] ?? 'Sem informação',
      neighborhood: json['bairro'] ?? 'Sem informação',
      reference: json['referencia'] ?? 'Sem informação',
      imageUrl: fullImageUrl,
      date: DateTime.tryParse(json['data_solicitacao'] ?? '') ?? DateTime.now(),
      categoryName: json['categoria']?['nome'] ?? json['categoria_nome'] ?? 'Sem Categoria',
      themeName: json['tema']?['nome'] ?? json['tema_nome'] ?? 'Sem Tema',
      userName: json['user']?['name'] ?? 'Anônimo',
      comments: parsedComments,
      latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
      isOwner: json['is_owner'] ?? false,
    );
  }
}
