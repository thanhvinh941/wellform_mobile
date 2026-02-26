import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/layout/main_layout.dart';
import '../features/exercise/presentation/screens/exercise_detail_screen.dart';
import '../features/exercise/presentation/screens/exercise_screen.dart';
import '../features/exercise/presentation/screens/segment_intro_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
// import '../features/settings/presentation/screens/settings_screen.dart';

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
            return ExerciseDetailScreen(id);
          },
        ),

        //exercise/:id/start
        GoRoute(
          path: 'exercise/:id/start',
          name: 'exercise-start',
          builder: (_, state) {
            return SegmentIntroScreen();
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
