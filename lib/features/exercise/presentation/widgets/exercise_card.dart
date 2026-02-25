import 'package:flutter/material.dart';

class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    super.key,
    required this.name,
    required this.levelText, // ví dụ: "Advanced"
    this.imageUrl,
    required this.duration, // đơn vị: giây
    this.focusAreas = const <String>[],
    this.equipments = const <String>[],
    this.onTap,
    this.badgeColor, // nếu không truyền sẽ dùng colorScheme.secondaryContainer
  });

  final String name;
  final String levelText;
  final String? imageUrl;
  final int duration;
  final List<String> focusAreas;
  final List<String> equipments;
  final VoidCallback? onTap;
  final Color? badgeColor;

  String _formatTime(int totalSeconds) {
    if (totalSeconds <= 0) return '—';
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    if (minutes > 0 && seconds > 0) return '${minutes}m ${seconds}s';
    if (minutes > 0) return '${minutes}m';
    return '${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card.outlined(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // -------- Title area (ảnh + badge level) ----------
            _HeaderImage(
              imageUrl: imageUrl,
              levelText: levelText,
              badgeColor: badgeColor ?? scheme.secondaryContainer,
              badgeTextColor: scheme.onSecondaryContainer,
            ),

            // -------- Phần nội dung với ListTile ----------
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + duration (icon + text) căn hai đầu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.access_time, size: 18, color: scheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            _formatTime(duration),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Focus Area
                  if (focusAreas.isNotEmpty)
                    _KeyValueRow(
                      label: 'Vùng cơ mục tiêu:',
                      value: focusAreas.join(', '),
                    ),

                  // Equipments
                  if (equipments.isNotEmpty)
                    _KeyValueRow(
                      label: 'Thiết bị:',
                      value: equipments.join(', '),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderImage extends StatelessWidget {
  const _HeaderImage({
    required this.imageUrl,
    required this.levelText,
    required this.badgeColor,
    required this.badgeTextColor,
  });

  final String? imageUrl;
  final String levelText;
  final Color badgeColor;
  final Color badgeTextColor;

  @override
  Widget build(BuildContext context) {
    const double headerHeight = 160;

    return SizedBox(
      height: headerHeight,               // ✔ Fixed height
      width: double.infinity,             // ✔ Stretch to card width
      child: Stack(
        fit: StackFit.expand,             // ✔ Fill available size safely
        children: [
          // Ảnh hoặc placeholder (bên trong luôn có size vì cha có size)
          if (imageUrl == null || imageUrl!.isEmpty)
            Container(
              color: Colors.grey.shade100,
              alignment: Alignment.center,
              child: Icon(Icons.image, size: 40, color: Colors.grey.shade400),
            )
          else
            Ink.image(
              image: NetworkImage(imageUrl!),
              fit: BoxFit.cover,
            ),

          // Badge
          Positioned(
            left: 12,
            top: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                levelText,
                style: TextStyle(
                  color: badgeTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: RichText(
        text: TextSpan(
          text: '$label ',
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: textTheme.bodyMedium?.color),
          children: [
            TextSpan(
              text: value,
              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
            ),
          ],
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}