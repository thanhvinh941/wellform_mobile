class FocusArea {
  final String id;
  final String keyText;
  const FocusArea({required this.id, required this.keyText});
}

class Equipment {
  final String id;
  final String keyText;
  const Equipment({required this.id, required this.keyText});
}

class Exercise {
  final String id;
  final String name;        // ex.name
  final String levelText;   // ex.levelText  (Beginner/Intermediate/Advanced)
  final String? imageUrl;   // ex.imageUrl
  final int duration;       // ex.duration (giây)
  final List<FocusArea> focusAreas; // ex.focusAreas
  final List<Equipment> equipments; // ex.equipments

  const Exercise({
    required this.id,
    required this.name,
    required this.levelText,
    required this.duration,
    required this.focusAreas,
    required this.equipments,
    this.imageUrl,
  });
}