import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/focus_area.dart';
import '../../domain/models/equipment.dart';

class StaticLocalDataSource {
  static const _kFocusAreas = 'static_focus_areas';
  static const _kEquipments = 'static_equipments';
  static const _kDifficulties = 'static_difficulties';
  static const _kTimestamp = 'static_timestamp';

  final Duration ttl; // thời gian cache
  StaticLocalDataSource({this.ttl = const Duration(days: 7)});

  Future<bool> get isExpired async {
    final sp = await SharedPreferences.getInstance();
    final ts = sp.getInt(_kTimestamp);
    if (ts == null) return true;
    final now = DateTime.now().millisecondsSinceEpoch;
    return now - ts > ttl.inMilliseconds;
  }

  Future<void> saveAll({
    required List<FocusArea> focusAreas,
    required List<Equipment> equipments,
    required List<String> difficulties,
  }) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kFocusAreas, jsonEncode(focusAreas.map((e) => e.toJson()).toList()));
    await sp.setString(_kEquipments, jsonEncode(equipments.map((e) => e.toJson()).toList()));
    await sp.setString(_kDifficulties, jsonEncode(difficulties));
    await sp.setInt(_kTimestamp, DateTime.now().millisecondsSinceEpoch);
  }

  Future<List<FocusArea>> readFocusAreas() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_kFocusAreas);
    if (raw == null) return [];
    final list = (jsonDecode(raw) as List).map((e) => FocusArea.fromJson(Map<String, dynamic>.from(e))).toList();
    return list;
  }

  Future<List<Equipment>> readEquipments() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_kEquipments);
    if (raw == null) return [];
    final list = (jsonDecode(raw) as List).map((e) => Equipment.fromJson(Map<String, dynamic>.from(e))).toList();
    return list;
  }

  Future<List<String>> readDifficulties() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_kDifficulties);
    if (raw == null) return [];
    return (jsonDecode(raw) as List).map((e) => e.toString()).toList();
  }

  Future<void> clear() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kFocusAreas);
    await sp.remove(_kEquipments);
    await sp.remove(_kDifficulties);
    await sp.remove(_kTimestamp);
  }
}