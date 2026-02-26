import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellform_mobile/features/exercise/domain/models/Exercise_set.dart';
import 'package:wellform_mobile/features/exercise/domain/models/segment.dart';
import 'package:wellform_mobile/features/exercise/presentation/providers/exercise_providers.dart';
import 'package:wellform_mobile/features/exercise/presentation/screens/segment_intro_screen.dart';

import '../../../../core/extensions/date_time.dart';
import '../../../../core/extensions/i18n_string.dart';
import '../../../../core/models/exercise_models.dart';
import '../../domain/models/equipment.dart';
import '../../domain/models/exercise_detail.dart';
import '../../domain/models/focus_area.dart';

/// ===== Screen =====
/// Bạn sẽ truyền exerciseId từ go_router và truyền detail + i18n sau khi fetch API.
/// Nếu detail = null -> hiện "Exercise not found".
class ExerciseDetailScreen extends ConsumerStatefulWidget {
  final String exerciseId;

  const ExerciseDetailScreen(this.exerciseId, {super.key});

  @override
  ConsumerState<ExerciseDetailScreen> createState() =>
      _ExerciseDetailScreen(exerciseId);
}

class _ExerciseDetailScreen extends ConsumerState<ExerciseDetailScreen> {
  final String exerciseId;

  @override
  void initState() {
    ref.read(exerciseRepoProvider).search();
  }

  /// Bản đồ i18n trả về từ API (_I18N).
  I18nMap? i18n;

  /// Callback khi bấm "Start Exercise"
  void onStart(String videoUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SegmentIntroScreen(),
      ),
    );
  }

  _ExerciseDetailScreen(this.exerciseId);

  @override
  Widget build(BuildContext context) {
    final d = ExerciseDetail(
      id: '',
      nameCode: 'Squat',
      level: 'Intermediate',
      imageUrl:
          'https://images.unsplash.com/photo-1599058917212-d750089bc07c?q=80&w=1200&auto=format&fit=crop',
      videoUrl:
          'https://images.unsplash.com/photo-1599058917212-d750089bc07c?q=80&w=1200&auto=format&fit=crop',
      duration: 50,
      focusAreas: const [
        FocusArea(id: 'fa_legs', keyCode: 'Legs'),
        FocusArea(id: 'fa_glutes', keyCode: 'Glutes'),
        FocusArea(id: 'fa_core', keyCode: 'Core'),
      ],
      equipments: const [Equipment(id: 'eq_body', keyCode: 'Bodyweight')],
      descriptionCode: '',
      segments: [
        Segment(
          'seg-1',
          'back',
          60,
          200,
          'https://images.unsplash.com/photo-1599058917212-d750089bc07c?q=80&w=1200&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1599058917212-d750089bc07c?q=80&w=1200&auto=format&fit=crop',
          [],
          'back 1',
          'back 1 des',
        ),
      ],
    );
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(d.nameCode.tr)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900; // breakpoint đơn giản
          final left = _LeftSection(
            detail: d,
            i18n: i18n,
            lang: 'vi',
            onStart: onStart,
          );
          final right = _RightSection(detail: d, i18n: i18n, lang: 'vi');

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
              children: [left, const SizedBox(height: 16), right],
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
                    child: Icon(
                      Icons.image,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                  )
                : Image.network(
                    detail.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade100,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.broken_image,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
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
        if (detail.descriptionCode.isNotEmpty) ...[
          _InfoBlock(
            title: '',
            body: (detail.descriptionCode ?? '').tr,
          ),
        ],

        if (detail.tips != null && detail.tips!.isNotEmpty) ...[
          const SizedBox(height: 12),
          _InfoBlock(
            title: '',
            body: detail.tips!.tr,
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
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
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

    final name = detail.nameCode.tr;
    final desc = (detail.descriptionCode).tr;
    final lvl = detail.level.tr;
    final focus = detail.focusAreas
        .map((e) => e.keyCode.tr)
        .join(', ');
    final equips = detail.equipments
        .map((e) => e.keyCode.tr)
        .join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Exercise Name + Description
        Text(
          name,
          style: theme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
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
          Text(
            'Segments',
            style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
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
          Text(
            '$label ',
            style: theme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
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
  const _SegmentsList({
    required this.segments,
    required this.i18n,
    required this.lang,
  });

  final List<Segment> segments;
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
        final title = s.nameCode.tr;

        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
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
                            child: Icon(
                              Icons.image,
                              size: 28,
                              color: Colors.grey.shade400,
                            ),
                          )
                        : Image.network(
                            s.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey.shade100,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.broken_image,
                                size: 28,
                                color: Colors.grey.shade400,
                              ),
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
                          Text(
                            title,
                            style: theme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Duration: ${formatTime(s.duration)}',
                        style: theme.bodySmall,
                      ),
                      if (s.restTime > 0)
                        Text(
                          'Rest: ${formatTime(s.restTime)}',
                          style: theme.bodySmall,
                        ),
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
