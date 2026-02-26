import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:wellform_mobile/features/exercise/presentation/providers/static_providers.dart';
import '../../data/datasources/exercise_remote_ds.dart';
import '../../data/repositories/exercise_repository.dart';
import '../../domain/models/exercise.dart';

final exerciseRepoProvider = Provider<ExerciseRepository>((ref) {
  final dio = ref.watch(apiClientProvider).dio;
  return ExerciseRepository(ExerciseRemoteDataSource(dio));
});

class ExerciseQuery {
  final String keyword;
  final List<String> focusAreas;
  final List<String> equipments;
  final String difficulty;
  final int page;
  final int pageSize;

  const ExerciseQuery({
    this.keyword = '',
    this.focusAreas = const [],
    this.equipments = const [],
    this.difficulty = 'all',
    this.page = 1,
    this.pageSize = 20,
  });

  ExerciseQuery copyWith({
    String? keyword,
    List<String>? focusAreas,
    List<String>? equipments,
    String? difficulty,
    int? page,
    int? pageSize,
  }) {
    return ExerciseQuery(
      keyword: keyword ?? this.keyword,
      focusAreas: focusAreas ?? this.focusAreas,
      equipments: equipments ?? this.equipments,
      difficulty: difficulty ?? this.difficulty,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

class ExerciseState {
  final bool loading;
  final List<Exercise>? items;
  final Object? error;
  final ExerciseQuery query;

  const ExerciseState({
    this.loading = false,
    this.items,
    this.error,
    this.query = const ExerciseQuery(),
  });

  ExerciseState copyWith({
    bool? loading,
    List<Exercise>? items,
    Object? error = Object,
    ExerciseQuery? query,
  }) {
    return ExerciseState(
      loading: loading ?? this.loading,
      items: items ?? this.items,
      error: error ?? this.error,
      query: query ?? this.query,
    );
  }
}
//
// class ExerciseNotifier extends StateNotifier<ExerciseState> {
//   final ExerciseRepository repo;
//   ExerciseNotifier(this.repo) : super(const ExerciseState());
//
//   Future<void> load() async {
//     state = state.copyWith(loading: true, error: null);
//     try {
//       final q = state.query;
//       final list = await repo.search(
//         keyword: q.keyword,
//         focusAreas: q.focusAreas,
//         difficulty: q.difficulty,
//         page: q.page,
//         pageSize: q.pageSize,
//       );
//       state = state.copyWith(loading: false, items: list);
//     } catch (e) {
//       state = state.copyWith(loading: false, error: e);
//     }
//   }
//
//   void setQuery(ExerciseQuery query, {bool autoLoad = true}) {
//     state = state.copyWith(query: query);
//     if (autoLoad) load();
//   }
// }
//
// final exerciseProvider =
// StateNotifierProvider<ExerciseNotifier, ExerciseState>((ref) {
//   final repo = ref.watch(exerciseRepoProvider);
//   return ExerciseNotifier(repo);
// });