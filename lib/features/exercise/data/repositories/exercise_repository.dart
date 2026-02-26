

import 'package:wellform_mobile/features/common/domain/api_response_models.dart';

import '../../../../core/models/exercise_models.dart';
import '../../../../core/store/I18n_store.dart';
import '../datasources/exercise_remote_ds.dart';

class ExerciseRepository {
  final ExerciseRemoteDataSource remote;
  ExerciseRepository(this.remote);

  Future<List<Exercise>?> search({
    String keyword = '',
    List<String> focusAreas = const [],
    List<String> equipments = const [],
    String difficulty = 'all',
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await remote.fetchExercisesRaw(
      keyword: keyword,
      focusAreas: focusAreas,
      equipments: equipments,
      difficulty: difficulty,
      page: page,
      pageSize: pageSize,
    );

    if (!response.success) {
      throw Exception('API returned success = false');
    }

    final results = response.results;

    if (results?.i18n != null) {
      I18NStore.instance.setData(results!.i18n);
    }

    return results?.data;
  }
}