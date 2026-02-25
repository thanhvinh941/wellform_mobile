import 'package:wellform_mobile/features/exercise/domain/models/segment.dart';

import '../../../../core/models/exercise_models.dart';

class ExerciseDetail {
  final String id;
  final String? imageUrl;
  final String? videoUrl;
  final String nameCode;
  final String descriptionCode;
  final String level;
  final int duration; // seconds
  final String? tips;
  final List<FocusArea> focusAreas;
  final List<Equipment> equipments;
  final List<Segment> segments;

  const ExerciseDetail({
    required this.id,
    this.imageUrl,
    this.videoUrl,
    required this.nameCode,
    required this.descriptionCode,
    required this.level,
    required this.duration,
    this.tips,
    required this.focusAreas,
    required this.equipments,
    required this.segments,
  });
}
