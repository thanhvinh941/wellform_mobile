import '../../features/exercise/domain/models/equipment.dart';
import '../../features/exercise/domain/models/focus_area.dart';

class Exercise {
  final String id;
  final String nameCode;        // ex.name
  final String levelCode;   // ex.levelCode  (Beginner/Intermediate/Advanced)
  final String? imageUrl;   // ex.imageUrl
  final int duration;       // ex.duration (giây)
  final List<FocusArea> focusAreas; // ex.focusAreas
  final List<Equipment> equipments; // ex.equipments

  const Exercise({
    required this.id,
    required this.nameCode,
    required this.levelCode,
    required this.duration,
    required this.focusAreas,
    required this.equipments,
    this.imageUrl,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id']?.toString() ?? '',
      nameCode: json['nameCode']?.toString() ?? '',
      levelCode: json['level']?.toString() ?? '',
      imageUrl: json['imageUrl'] as String?,
      duration: json['duration'] == null
          ? 0
          : (json['duration'] as num).toInt(),
      focusAreas: (json['focusAreas'] as List<dynamic>?)
          ?.map((e) => FocusArea.fromJson(e as Map<String, dynamic>))
          .toList() ??
          const [],
      equipments: (json['equipments'] as List<dynamic>?)
          ?.map((e) => Equipment.fromJson(e as Map<String, dynamic>))
          .toList() ??
          const [],
    );
  }
}