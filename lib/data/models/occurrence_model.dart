//define status possiveis
enum OccurrenceStatus { recebido, emAnalise, emAndamento, resolvido }

class Occurrence {
  final String id;
  final String title;
  final String description;
  final String address;
  final OccurrenceStatus status;
  final String imageUrl; //url imagem

  Occurrence({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.status,
    required this.imageUrl,
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
    } 
    else if (imagePath.isNotEmpty) {
      final String baseUrl = 'http://127.0.0.1:8000/api'; 
      final String filename = imagePath.split('/').last;
      
      fullImageUrl = '$baseUrl/images/$filename';
    } 
    else {
      fullImageUrl = '';
    }

    return Occurrence(
      id: json['id'].toString(),
      title: json['titulo'] ?? 'Título não informado',
      description: json['descricao'] ?? 'Sem descrição',
      address: json['localizacao'] ?? 'Endereço não informado',
      imageUrl: fullImageUrl,
      status: status,
    );
  }
}
