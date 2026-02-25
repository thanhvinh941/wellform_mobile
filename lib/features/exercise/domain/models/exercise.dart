import 'focus_area.dart';
import 'equipment.dart';

class Exercise {
  final String id;
  final String name;
  final String levelText;
  final String? imageUrl;
  final int duration; // seconds
  final List<FocusArea> focusAreas;
  final List<Equipment> equipments;

  const Exercise({
    required this.id,
    required this.name,
    required this.levelText,
    required this.duration,
    required this.focusAreas,
    required this.equipments,
    this.imageUrl,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    id: json['id'].toString(),
    name: json['name'] as String? ?? '',
    levelText: json['levelText'] as String? ?? '',
    imageUrl: json['imageUrl'] as String?,
    duration: (json['duration'] as num?)?.toInt() ?? 0,
    focusAreas: (json['focusAreas'] as List? ?? [])
        .map((e) => FocusArea.fromJson(Map<String, dynamic>.from(e)))
        .toList(),
    equipments: (json['equipments'] as List? ?? [])
        .map((e) => Equipment.fromJson(Map<String, dynamic>.from(e)))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'levelText': levelText,
    'imageUrl': imageUrl,
    'duration': duration,
    'focusAreas': focusAreas.map((e) => e.toJson()).toList(),
    'equipments': equipments.map((e) => e.toJson()).toList(),
  };
}