import '../datasources/exercise_remote_ds.dart';

class ExerciseRepository {
  final ExerciseRemoteDataSource remote;
  ExerciseRepository(this.remote);

  Future<ExerciseSearchResult> search({
    String keyword = '',
    List<String> focusAreas = const [],
    List<String> equipments = const [],
    String difficulty = 'all',
    int page = 1,
    int pageSize = 20,
  }) {
    return remote.fetchExercises(
      keyword: keyword,
      focusAreas: focusAreas,
      equipments: equipments,
      difficulty: difficulty,
      page: page,
      pageSize: pageSize,
    );
  }
}