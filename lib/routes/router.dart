import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/layout/main_layout.dart';
import '../features/exercise/presentation/screens/exercise_detail_screen.dart';
import '../features/exercise/presentation/screens/exercise_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
// import '../features/settings/presentation/screens/settings_screen.dart';

final fakeI18n = {
  'en': {
    'ex.push-seg.name': 'Push Up',
    'df.advan.name': 'Advanced',
    'cat.warmup': 'Warmup',
    'seg.plank.name': 'Plank Hold',
  }
};

final fakeDetail = ExerciseDetail(
  id: '1',
  nameCode: 'ex.push-seg.name',
  levelCode: 'df.advan.name',
  descriptionCode: 'Push-up basic movement.',
  tipsCode: 'Keep your core tight.',
  imageUrl: 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438',
  videoUrl: 'https://example.com/video.mp4',
  duration: 90,
  focusAreaCodes: const ['Chest', 'Core'],
  equipmentCodes: const ['Bodyweight'],
  segments: const [
    ExerciseSegment(
      nameCode: 'seg.plank.name',
      categoryCode: 'cat.warmup',
      duration: 30,
      restTime: 10,
      imageUrl: null,
    ),
  ],
);

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'main',
      builder: (_, __) => const MainLayout(),
      routes: [
        GoRoute(
          path: 'exercise',
          name: 'exercise',
          builder: (_, __) {
            return ExerciseScreen();
          },
        ),

        //exercise/:id
        GoRoute(
          path: 'exercise/:id',
          name: 'exercise-detail',
          builder: (_, state) {
            final id = state.pathParameters['id']!;
            return ExerciseDetailScreen(
                exerciseId: '1',
                detail: fakeDetail,
                i18n: fakeI18n,
                lang: 'en',
                onStart: (url) => debugPrint('Start video: $url'),
              );
          },
        ),

        // /profile
        GoRoute(
          path: 'profile',
          name: 'profile',
          builder: (_, __) => const ProfileScreen(),
        ),

        // /settings
        // GoRoute(
        //   path: 'settings',
        //   name: 'settings',
        //   builder: (_, __) => const SettingsScreen(),
        // ),
      ],
    ),
  ],
);