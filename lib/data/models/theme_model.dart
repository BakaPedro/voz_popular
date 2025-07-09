class ThemeModel {
  final int id;
  final String name;

  ThemeModel({required this.id, required this.name});

  factory ThemeModel.fromJson(Map<String, dynamic> json) {
    return ThemeModel(
      id: json['id'],
      name: json['nome'] ?? 'Sem nome',
    );
  }
}