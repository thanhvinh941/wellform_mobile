
/// ===== Helpers =====
String formatTime(int? totalSeconds) {
  if (totalSeconds == null || totalSeconds <= 0) return '—';
  final m = totalSeconds ~/ 60;
  final s = totalSeconds % 60;
  if (m > 0 && s > 0) return '${m}m ${s}s';
  if (m > 0) return '${m}m';
  return '${s}s';
}