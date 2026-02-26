import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/static_local_ds.dart';
import '../../data/datasources/static_remote_ds.dart';
import '../../data/repositories/static_repository.dart';
import '../../domain/models/focus_area.dart';
import '../../domain/models/equipment.dart';

// ApiClient
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient.create(baseUrl: 'http://localhost:8080'); // TODO: set thật
});

// Repo
final staticRepoProvider = Provider<StaticRepository>((ref) {
  final dio = ref.watch(apiClientProvider).dio;
  return StaticRepository(
    remote: StaticRemoteDataSource(dio),
    local: StaticLocalDataSource(ttl: const Duration(days: 7)),
  );
});

// Notifier/State – Load all static
class StaticState {
  final bool loading;
  final List<FocusArea> focusAreas;
  final List<Equipment> equipments;
  final List<String> difficulties;
  final Object? error;

  const StaticState({
    this.loading = false,
    this.focusAreas = const [],
    this.equipments = const [],
    this.difficulties = const [],
    this.error,
  });

  StaticState copyWith({
    bool? loading,
    List<FocusArea>? focusAreas,
    List<Equipment>? equipments,
    List<String>? difficulties,
    Object? error = Object,
  }) {
    return StaticState(
      loading: loading ?? this.loading,
      focusAreas: focusAreas ?? this.focusAreas,
      equipments: equipments ?? this.equipments,
      difficulties: difficulties ?? this.difficulties,
      error: error ?? this.error,
    );
  }
}

class StaticNotifier extends StateNotifier<StaticState> {
  final StaticRepository repo;
  StaticNotifier(this.repo) : super(const StaticState());

  Future<void> load() async {
    state = state.copyWith(loading: true, error: null);
    try {
      // final all = await repo.getAll();
      state = state.copyWith(
        loading: false,
        // focusAreas: all.focusAreas,
        // equipments: all.equipments,
        // difficulties: all.difficulties,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e);
    }
  }

  Future<void> refresh() => load();
}

final staticProvider = StateNotifierProvider<StaticNotifier, StaticState>((ref) {
  final repo = ref.watch(staticRepoProvider);
  return StaticNotifier(repo);
});