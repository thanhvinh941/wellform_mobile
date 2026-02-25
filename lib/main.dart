import 'package:flutter/material.dart';
import 'package:wellform_mobile/routes/router.dart';
import 'core/layout/main_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() {
  runApp(const ProviderScope(child: MyApp())); // 👈 BẮT BUỘC CÓ
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF073B3A), // 🌟 primary chính
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF073B3A), // 🌟 primary chính
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212), // nền dark đẹp
      ),

      themeMode: ThemeMode.system,
    );
  }
}