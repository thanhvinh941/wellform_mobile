import 'package:flutter/material.dart';

/// ===== I18N support (thay cho pipe Angular) =====
typedef I18nMap = Map<String, Map<String, String>>;

extension I18nStringX on String {
  String tr(
      I18nMap? i18n, {
        String lang = 'en',
        String? fallbackLang,
      }) {
    if (i18n == null || i18n.isEmpty) return this;
    final s1 = i18n[lang]?[this];
    if (s1 != null && s1.isNotEmpty) return s1;
    if (fallbackLang != null) {
      final s2 = i18n[fallbackLang]?[this];
      if (s2 != null && s2.isNotEmpty) return s2;
    }
    for (final e in i18n.entries) {
      final s = e.value[this];
      if (s != null && s.isNotEmpty) return s;
    }
    return this; // fallback về keyCode nếu không có i18n
  }
}

/// ===== Helpers =====
String formatTime(int? totalSeconds) {
  if (totalSeconds == null || totalSeconds <= 0) return '—';
  final m = totalSeconds ~/ 60;
  final s = totalSeconds % 60;
  if (m > 0 && s > 0) return '${m}m ${s}s';
  if (m > 0) return '${m}m';
  return '${s}s';
}

/// ===== Models (tối thiểu cho UI) =====
class ExerciseSegment {
  final String nameCode;
  final String categoryCode;
  final int duration; // seconds
  final int? restTime; // seconds
  final String? imageUrl;

  const ExerciseSegment({
    required this.nameCode,
    required this.categoryCode,
    required this.duration,
    this.restTime,
    this.imageUrl,
  });
}

class ExerciseDetail {
  final String id;
  final String nameCode;
  final String? descriptionCode;
  final String? tipsCode;
  final String? imageUrl;
  final String? videoUrl;
  final int? duration; // seconds
  final String levelCode;
  final List<String> focusAreaCodes; // keyCode
  final List<String> equipmentCodes; // keyCode
  final List<ExerciseSegment> segments;

  const ExerciseDetail({
    required this.id,
    required this.nameCode,
    required this.levelCode,
    this.descriptionCode,
    this.tipsCode,
    this.imageUrl,
    this.videoUrl,
    this.duration,
    this.focusAreaCodes = const [],
    this.equipmentCodes = const [],
    this.segments = const [],
  });
}

/// ===== Screen =====
/// Bạn sẽ truyền exerciseId từ go_router và truyền detail + i18n sau khi fetch API.
/// Nếu detail = null -> hiện "Exercise not found".
class ExerciseDetailScreen extends StatelessWidget {
  final String exerciseId;

  /// Dữ liệu chi tiết (khi đã fetch xong). Nếu null, hiển thị empty state.
  final ExerciseDetail? detail;

  /// Bản đồ i18n trả về từ API (_I18N).
  final I18nMap? i18n;

  /// Ngôn ngữ muốn hiển thị (ví dụ: 'en', 'vi'...)
  final String lang;

  /// Callback khi bấm "Start Exercise"
  final void Function(String videoUrl)? onStart;

  const ExerciseDetailScreen({
    super.key,
    required this.exerciseId,
    this.detail,
    this.i18n,
    this.lang = 'en',
    this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final d = detail;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(d == null ? 'Exercise Detail' : d.nameCode.tr(i18n, lang: lang)),
      ),
      body: d == null
          ? _EmptyState()
          : LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900; // breakpoint đơn giản
          final left = _LeftSection(
            detail: d,
            i18n: i18n,
            lang: lang,
            onStart: onStart,
          );
          final right = _RightSection(
            detail: d,
            i18n: i18n,
            lang: lang,
          );

          if (isWide) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: left),
                  const SizedBox(width: 24),
                  Expanded(flex: 5, child: right),
                ],
              ),
            );
          }
          // Mobile: xếp dọc
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                left,
                const SizedBox(height: 16),
                right,
              ],
            ),
          );
        },
      ),
    );
  }
}

/// ===== Left section: Image + Start Button + Description/Tips =====
class _LeftSection extends StatelessWidget {
  const _LeftSection({
    required this.detail,
    required this.i18n,
    required this.lang,
    required this.onStart,
  });

  final ExerciseDetail detail;
  final I18nMap? i18n;
  final String lang;
  final void Function(String videoUrl)? onStart;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Image wrapper
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: detail.imageUrl == null || detail.imageUrl!.isEmpty
                ? Container(
              color: Colors.grey.shade100,
              alignment: Alignment.center,
              child: Icon(Icons.image, size: 48, color: Colors.grey.shade400),
            )
                : Image.network(
              detail.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey.shade100,
                alignment: Alignment.center,
                child: Icon(Icons.broken_image, size: 48, color: Colors.grey.shade400),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Start Exercise button
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.icon(
            onPressed: (detail.videoUrl != null && detail.videoUrl!.isNotEmpty)
                ? () => onStart?.call(detail.videoUrl!)
                : null,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Exercise'),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Description & Tips
        _InfoBlock(
          title: 'Description',
          body: (detail.descriptionCode ?? '').tr(i18n, lang: lang),
        ),
        if (detail.tipsCode != null && detail.tipsCode!.isNotEmpty) ...[
          const SizedBox(height: 12),
          _InfoBlock(
            title: 'Tips',
            body: detail.tipsCode!.tr(i18n, lang: lang),
          ),
        ],
      ],
    );
  }
}

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(body, style: theme.bodyMedium),
        ],
      ),
    );
  }
}

/// ===== Right section: Title + Quick Stats + Segments (if any) =====
class _RightSection extends StatelessWidget {
  const _RightSection({
    required this.detail,
    required this.i18n,
    required this.lang,
  });

  final ExerciseDetail detail;
  final I18nMap? i18n;
  final String lang;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    final name = detail.nameCode.tr(i18n, lang: lang);
    final desc = (detail.descriptionCode ?? '').tr(i18n, lang: lang);
    final lvl = detail.levelCode.tr(i18n, lang: lang);
    final focus = detail.focusAreaCodes.map((e) => e.tr(i18n, lang: lang)).join(', ');
    final equips = detail.equipmentCodes.map((e) => e.tr(i18n, lang: lang)).join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Exercise Name + Description
        Text(name, style: theme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
        if (desc.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(desc, style: theme.bodyMedium),
        ],

        const SizedBox(height: 16),

        // Stats block
        Divider(color: scheme.outlineVariant),
        const SizedBox(height: 12),
        _StatsGrid(
          durationCode: formatTime(detail.duration),
          difficultyCode: lvl,
          focusAreasCode: focus.isEmpty ? '—' : focus,
          equipmentsCode: equips.isEmpty ? '—' : equips,
        ),

        const SizedBox(height: 16),

        // Segments (if any)
        if (detail.segments.isNotEmpty) ...[
          Text('Segments', style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          _SegmentsList(segments: detail.segments, i18n: i18n, lang: lang),
        ],
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({
    required this.durationCode,
    required this.difficultyCode,
    required this.focusAreasCode,
    required this.equipmentsCode,
  });

  final String durationCode;
  final String difficultyCode;
  final String focusAreasCode;
  final String equipmentsCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    Widget item(String label, String value) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label ', style: theme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          Expanded(
            child: Text(
              value,
              style: theme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        item('Duration:', durationCode),
        const SizedBox(height: 8),
        item('Difficulty:', difficultyCode),
        const SizedBox(height: 8),
        item('Focus Area:', focusAreasCode),
        const SizedBox(height: 8),
        item('Equipments:', equipmentsCode),
      ],
    );
  }
}

class _SegmentsList extends StatelessWidget {
  const _SegmentsList({required this.segments, required this.i18n, required this.lang});

  final List<ExerciseSegment> segments;
  final I18nMap? i18n;
  final String lang;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: segments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final s = segments[index];
        final title = s.nameCode.tr(i18n, lang: lang);
        final cat = s.categoryCode.tr(i18n, lang: lang);

        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // thumb
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 72,
                    height: 72,
                    child: s.imageUrl == null || s.imageUrl!.isEmpty
                        ? Container(
                      color: Colors.grey.shade100,
                      alignment: Alignment.center,
                      child: Icon(Icons.image, size: 28, color: Colors.grey.shade400),
                    )
                        : Image.network(
                      s.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade100,
                        alignment: Alignment.center,
                        child: Icon(Icons.broken_image, size: 28, color: Colors.grey.shade400),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // category + title
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(cat, style: theme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.primary)),
                          Text(title, style: theme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('Duration: ${formatTime(s.duration)}', style: theme.bodySmall),
                      if (s.restTime != null && s.restTime! > 0)
                        Text('Rest: ${formatTime(s.restTime)}', style: theme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Exercise not found',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
