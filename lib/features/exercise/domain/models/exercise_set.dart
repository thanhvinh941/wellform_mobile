class ExerciseSet {
  final String reps; // number or 'AMRAP'
  final int rest; // seconds
  final String target; // 'light', 'heavy', 'burn'
  final int completedReps;

  ExerciseSet({required this.reps, required this.rest, required this.target, required this.completedReps});
}