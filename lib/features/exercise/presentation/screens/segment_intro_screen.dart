import 'package:flutter/material.dart';
import 'package:wellform_mobile/features/exercise/domain/models/exercise_detail.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../core/models/exercise_models.dart';
import '../../domain/models/Exercise_set.dart';
import '../../domain/models/equipment.dart';
import '../../domain/models/focus_area.dart';
import '../../domain/models/segment.dart';

// youtube_utils.dart
String? extractYoutubeId(String url) {
  final regExp = RegExp(
    r'(?:(?:youtu\.be/|youtube\.com/(?:watch\?(?:.*&)?v=|embed/|v/)))([A-Za-z0-9_-]{11})',
    caseSensitive: false,
  );
  final match = regExp.firstMatch(url);
  if (match != null && match.groupCount >= 1) {
    return match.group(1);
  }
  return null;
}

class SegmentIntroScreen extends StatefulWidget {

  ExerciseDetail exercise = ExerciseDetail(
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

  @override
  State<StatefulWidget> createState() => _SegmentIntroScreenState();
}

class _SegmentIntroScreenState extends State<SegmentIntroScreen> {
  final int currentSegmentIndex = 0;
  YoutubePlayerController? _ytController;

  Segment get currentSegment =>
      widget.exercise.segments[currentSegmentIndex];
  int get totalSegments => widget.exercise.segments.length;

  int get totalSetsInSegment => currentSegment.sets.length;
  int get restSeconds => currentSegment.sets.isNotEmpty
      ? (currentSegment.sets.first.rest ?? 0)
      : 0;

  @override
  void initState() {
    super.initState();
    _initYoutube();
  }

  void _initYoutube() {
    final url = currentSegment.videoUrl;
    if (url == null) return;

    final id = extractYoutubeId(url);
    if (id == null) return;

    _ytController = YoutubePlayerController(
      initialVideoId: id,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        loop: false,
        controlsVisibleAtStart: true,
        forceHD: false,
      ),
    );
  }

  void onStartSegment(){

  }

  @override
  void dispose() {
    _ytController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Màu + padding chung
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SEGMENT ${currentSegmentIndex + 1} / $totalSegments',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              currentSegment.nameCode,
              style: textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _InfoCard(
                segmentName: currentSegment.nameCode,
                focus: currentSegment.focus ?? 'N/A',
                totalSets: totalSetsInSegment,
                restSeconds: restSeconds,
              ),
              const SizedBox(height: 16),
              _VideoBox(
                controller: _ytController,
                hasVideo:
                    currentSegment.videoUrl != null && _ytController != null,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: onStartSegment,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    'START SEGMENT',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String segmentName;
  final String focus;
  final int totalSets;
  final int restSeconds;

  const _InfoCard({
    required this.segmentName,
    required this.focus,
    required this.totalSets,
    required this.restSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DefaultTextStyle(
          style: textTheme.bodyMedium!.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                segmentName,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _ChipInfo(
                    icon: Icons.document_scanner,
                    label: 'Focus',
                    value: focus,
                  ),
                  const SizedBox(width: 8),
                  _ChipInfo(
                    icon: Icons.format_list_numbered,
                    label: 'Sets',
                    value: '$totalSets',
                  ),
                  const SizedBox(width: 8),
                  _ChipInfo(
                    icon: Icons.timer,
                    label: 'Rest',
                    value: restSeconds > 0 ? '${restSeconds}s' : '—',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChipInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ChipInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _VideoBox extends StatelessWidget {
  final YoutubePlayerController? controller;
  final bool hasVideo;

  const _VideoBox({required this.controller, required this.hasVideo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (!hasVideo) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.ondemand_video,
                size: 42,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 8),
              Text(
                'Video guide not available',
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: YoutubePlayer(
          controller: controller!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
