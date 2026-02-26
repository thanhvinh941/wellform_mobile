import 'exercise_set.dart';

class Segment {
  final String id;
  final String focus;
  final int restTime;
  final int duration;
  final String imageUrl;
  final String videoUrl;
  final List<ExerciseSet> sets;
  final String nameCode;

  final String descriptionCode;

  Segment(this.id, this.focus, this.restTime, this.duration, this.imageUrl,
      this.videoUrl, this.sets, this.nameCode, this.descriptionCode);
}