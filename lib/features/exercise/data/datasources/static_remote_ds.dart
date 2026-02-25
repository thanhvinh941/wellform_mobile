import 'package:dio/dio.dart';

import '../../domain/models/focus_area.dart';
import '../../domain/models/equipment.dart';

class StaticRemoteDataSource {
  final Dio dio;
  StaticRemoteDataSource(this.dio);

  Future<List<FocusArea>> fetchFocusAreas() async {
    final res = await dio.get('/external/master/focus-areas');
    final list = (res.data as List).map((e) => FocusArea.fromJson(Map<String, dynamic>.from(e))).toList();
    return list;
  }

  Future<List<Equipment>> fetchEquipments() async {
    final res = await dio.get('/external/master/equipments');
    final list = (res.data as List).map((e) => Equipment.fromJson(Map<String, dynamic>.from(e))).toList();
    return list;
  }

  /// Difficulty nếu backend trả tĩnh (strings)
  Future<List<String>> fetchDifficulties() async {
    final res = await dio.get('/external/master/levels'); // ['easy','medium','hard']
    return (res.data as List).map((e) => e.toString()).toList();
  }
}