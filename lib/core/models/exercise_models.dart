class FocusArea {
  final String id;
  final String keyCode;
  const FocusArea({required this.id, required this.keyCode});
}

class Equipment {
  final String id;
  final String keyCode;
  const Equipment({required this.id, required this.keyCode});
}

class Exercise {
  final String id;
  final String name;        // ex.name
  final String levelCode;   // ex.levelCode  (Beginner/Intermediate/Advanced)
  final String? imageUrl;   // ex.imageUrl
  final int duration;       // ex.duration (giây)
  final List<FocusArea> focusAreas; // ex.focusAreas
  final List<Equipment> equipments; // ex.equipments

  const Exercise({
    required this.id,
    required this.name,
    required this.levelCode,
    required this.duration,
    required this.focusAreas,
    required this.equipments,
    this.imageUrl,
  });
}