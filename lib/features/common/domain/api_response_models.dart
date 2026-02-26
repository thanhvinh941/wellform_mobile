import 'dart:convert';

/// Kiểu i18n: langCode -> (keyCode -> localized string)
/// Ví dụ: { "en": { "df.advan.name": "Advanced", "ex.push-seg.name": "push up" } }
typedef I18nMap = Map<String, Map<String, String>>;

/// Model ROOT chung cho mọi API theo format:
/// { "success": true, "results": { "_I18N": {...}, "DATA": [...] } }
class ApiResponse<T> {
  final bool success;
  final Results<T>? results;

  const ApiResponse({
    required this.success,
    required this.results,
  });

  /// Parse JSON với hàm chuyển từng phần tử DATA -> T
  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic> e) fromData,
      ) {
    return ApiResponse<T>(
      success: json['success'] == true,
      results: json['results'] == null
          ? null
          : Results<T>.fromJson(
        Map<String, dynamic>.from(json['results']),
        fromData,
      ),
    );
  }

  Map<String, dynamic> toJson(
      Map<String, dynamic> Function(T e) toData,
      ) {
    return {
      'success': success,
      'results': results?.toJson(toData),
    };
  }

  /// Hỗ trợ parse thẳng từ string JSON
  static ApiResponse<T> parse<T>(
      String source,
      T Function(Map<String, dynamic> e) fromData,
      ) {
    final map = jsonDecode(source) as Map<String, dynamic>;
    return ApiResponse<T>.fromJson(map, fromData);
  }
}

/// Phần "results" chứa i18n + danh sách dữ liệu
class Results<T> {
  final I18nMap i18n;
  final List<T> data;

  const Results({
    required this.i18n,
    required this.data,
  });

  factory Results.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic> e) fromData,
      ) {
    final rawI18n = (json['_I18N'] as Map?) ?? const {};
    // Chuẩn hóa _I18N về Map<String, Map<String, String>>
    final i18n = <String, Map<String, String>>{};
    rawI18n.forEach((lang, dict) {
      if (dict is Map) {
        i18n[lang.toString()] = dict.map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''));
      }
    });

    final rawList = (json['DATA'] as List?) ?? const [];
    final items = <T>[];
    for (final e in rawList) {
      if (e is Map) {
        items.add(fromData(Map<String, dynamic>.from(e)));
      }
    }
    return Results<T>(
      i18n: i18n,
      data: items,
    );
  }

  Map<String, dynamic> toJson(
      Map<String, dynamic> Function(T e) toData,
      ) {
    return {
      '_I18N': i18n,
      'DATA': data.map(toData).toList(),
    };
  }

  /// Lấy chuỗi i18n theo lang và key code. Nếu không có sẽ trả về fallback:
  /// - nếu có defaultLang, thử lang đó
  /// - nếu không có, trả lại chính keyCode
  String t(String keyCode, {String? lang, String? defaultLang}) {
    // Ưu tiên lang
    if (lang != null) {
      final s = i18n[lang]?[keyCode];
      if (s != null && s.isNotEmpty) return s;
    }
    // Thử defaultLang
    if (defaultLang != null) {
      final s = i18n[defaultLang]?[keyCode];
      if (s != null && s.isNotEmpty) return s;
    }
    // Thử bất kỳ lang nào có key đó
    for (final entry in i18n.entries) {
      final s = entry.value[keyCode];
      if (s != null && s.isNotEmpty) return s;
    }
    // Fallback trả lại code
    return keyCode;
  }
}
//
// ////////////////////////////////////////////////////////////////////////////////
// /// Ví dụ: Model Exercise + cách parse từ DATA và dùng i18n
// ////////////////////////////////////////////////////////////////////////////////
//
// class Exercise {
//   final String id;
//   final String? imageUrl;
//   final int? duration; // seconds (null nếu không có)
//   final String levelCode; // ví dụ: "df.advan.name"
//   final String nameCode;  // ví dụ: "ex.push-seg.name"
//   final List<String> focusAreas; // để trống theo sample
//   final List<String> equipments; // để trống theo sample
//
//   const Exercise({
//     required this.id,
//     required this.imageUrl,
//     required this.duration,
//     required this.levelCode,
//     required this.nameCode,
//     required this.focusAreas,
//     required this.equipments,
//   });
//
//   factory Exercise.fromJson(Map<String, dynamic> json) {
//     return Exercise(
//       id: json['id']?.toString() ?? '',
//       imageUrl: json['imageUrl'] as String?,
//       duration: json['duration'] == null ? null : (json['duration'] as num).toInt(),
//       levelCode: json['level']?.toString() ?? '',
//       nameCode: json['nameCode']?.toString() ?? '',
//       focusAreas: ((json['focusAreas'] as List?) ?? const [])
//           .map((e) => e?.toString() ?? '')
//           .where((e) => e.isNotEmpty)
//           .toList(),
//       equipments: ((json['equipments'] as List?) ?? const [])
//           .map((e) => e?.toString() ?? '')
//           .where((e) => e.isNotEmpty)
//           .toList(),
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'imageUrl': imageUrl,
//     'duration': duration,
//     'level': levelCode,
//     'nameCode': nameCode,
//     'focusAreas': focusAreas,
//     'equipments': equipments,
//   };
//
//   /// Lấy tên hiển thị theo i18n map.
//   String localizedName(I18nMap i18n, {String lang = 'vi', String? fallbackLang}) {
//     final results = Results<Never>(i18n: i18n, data: const []);
//     return results.t(nameCode, lang: lang, defaultLang: fallbackLang);
//   }
//
//   String localizedLevel(I18nMap i18n, {String lang = 'vi', String? fallbackLang}) {
//     final results = Results<Never>(i18n: i18n, data: const []);
//     return results.t(levelCode, lang: lang, defaultLang: fallbackLang);
//   }
// }