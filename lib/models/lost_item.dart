// lib/models/lost_item.dart

class LostItem {
  final String category;
  final String stationName;
  final String trainNumber;
  final String description;

  LostItem({
    required this.category,
    required this.stationName,
    required this.trainNumber,
    required this.description,
  });

  factory LostItem.fromJson(Map<String, dynamic> json) {
    return LostItem(
      category: json['fields']['category'] ?? 'Inconnu',
      stationName: json['fields']['station_name'] ?? 'Inconnu',
      trainNumber: json['fields']['train_number'] ?? 'Inconnu',
      description: json['fields']['description'] ?? 'Aucune description',
    );
  }
}
