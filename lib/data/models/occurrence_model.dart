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
}