class ExerciseSet {
  final String reps; // number or 'AMRAP'
  final int rest; // seconds
  final String target; // 'light', 'heavy', 'burn'
  final int completedReps;

  ExerciseSet(this.reps, this.rest, this.target, this.completedReps);
}