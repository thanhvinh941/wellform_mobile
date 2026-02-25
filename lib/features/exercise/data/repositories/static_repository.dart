import '../datasources/static_local_ds.dart';
import '../datasources/static_remote_ds.dart';
import '../../domain/models/focus_area.dart';
import '../../domain/models/equipment.dart';

class StaticRepository {
  final StaticRemoteDataSource remote;
  final StaticLocalDataSource local;

  StaticRepository({required this.remote, required this.local});

  /// Lấy static ưu tiên local cache; nếu hết hạn thì refresh remote và lưu lại.
  Future<({List<FocusArea> focusAreas, List<Equipment> equipments, List<String> difficulties})> getAll() async {
    final expired = await local.isExpired;

    if (!expired) {
      final fa = await local.readFocusAreas();
      final eq = await local.readEquipments();
      final df = await local.readDifficulties();
      if (fa.isNotEmpty || eq.isNotEmpty || df.isNotEmpty) {
        return (focusAreas: fa, equipments: eq, difficulties: df);
      }
    }

    // Fetch remote và lưu
    final fa = await remote.fetchFocusAreas();
    final eq = await remote.fetchEquipments();
    final df = await remote.fetchDifficulties();
    await local.saveAll(focusAreas: fa, equipments: eq, difficulties: df);
    return (focusAreas: fa, equipments: eq, difficulties: df);
  }

  Future<void> refresh() async {
    final fa = await remote.fetchFocusAreas();
    final eq = await remote.fetchEquipments();
    final df = await remote.fetchDifficulties();
    await local.saveAll(focusAreas: fa, equipments: eq, difficulties: df);
  }
}