import 'package:intl/intl.dart';

class Comment {
  final int id;
  final String content;
  final String userName;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.content,
    required this.userName,
    required this.createdAt,
  });

  String get formattedDate {
    return DateFormat('dd/MM/yyyy \'às\' HH:mm').format(createdAt);
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['conteudo'] ?? '',
      userName: json['user'] != null ? json['user']['name'] ?? 'Anônimo' : 'Anônimo',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}
