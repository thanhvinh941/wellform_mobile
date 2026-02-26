import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../../../../core/models/exercise_models.dart';
import '../../../common/domain/api_response_models.dart';

// Import các model & typedef đã định nghĩa trong api_response_models.dart


/// Kết quả tìm kiếm: gồm danh sách items + i18n + cờ success
class ExerciseSearchResult {
  final bool success;
  final List<Exercise> items;
  final I18nMap i18n;

  const ExerciseSearchResult({
    required this.success,
    required this.items,
    required this.i18n,
  });
}

class ExerciseRemoteDataSource {
  final Dio dio;
  const ExerciseRemoteDataSource(this.dio);

  /// filters:
  /// - keyword
  /// - focusAreas: List<String>
  /// - equipments: List<String>
  /// - difficulty: 'all' | 'easy' | 'medium' | 'hard' (server nhận 'level')
  /// - page / pageSize
  Future<ApiResponse<Exercise>> fetchExercises({
    String keyword = '',
    List<String> focusAreas = const [],
    List<String> equipments = const [],
    String difficulty = 'all',
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final payload = <String, dynamic>{
        if(keyword.isNotEmpty) 'keyword': keyword,
        'focusAreas': focusAreas.isNotEmpty ? focusAreas.join(',') : [], // giữ nguyên theo code cũ
        'equipments': equipments.isNotEmpty ? equipments.join(',') : [],
        'level': difficulty != 'all' ? difficulty : [],
      };

      final res = await dio.post(
        'http://localhost:8089/external/exercises/by-w/null/search',
        data: payload,
      );

      final api = ApiResponse<Exercise>.fromJson(
        Map<String, dynamic>.from(res.data as Map),
            (e) => Exercise.fromJson(e),
      );

      return api;
    } on DioException catch (e) {
      // Bạn có thể log e.response?.data để debug thêm
      throw Exception('fetchExercises failed: ${e.message}');
    } on FormatException catch (e) {
      throw Exception('fetchExercises parse error: ${e.message}');
    }
  }

  /// (Tùy chọn) Nếu bạn muốn lấy RAW ApiResponse để xử lý ở tầng repo:
  Future<ApiResponse<Exercise>> fetchExercisesRaw({
    String keyword = '',
    List<String> focusAreas = const [],
    List<String> equipments = const [],
    String difficulty = 'all',
    int page = 1,
    int pageSize = 20,
  }) async {
    final payload = <String, dynamic>{
      if (keyword.isNotEmpty) 'keyword': keyword,
      if (focusAreas.isNotEmpty) 'focusAreas': focusAreas.join(','),
      if (equipments.isNotEmpty) 'equipments': equipments.join(','),
      if (difficulty != 'all') 'level': difficulty,
      'page': page,
      'pageSize': pageSize,
    };

    final Response res = await dio.post(
      '/external/exercises/by-w/null/search',
      data: payload,
    );

    if (res.data is! Map) {
      throw const FormatException('Unexpected response type: root is not a Map');
    }

    return ApiResponse<Exercise>.fromJson(
      Map<String, dynamic>.from(res.data as Map),
          (e) => Exercise.fromJson(e),
    );
  }
}