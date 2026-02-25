import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:wellform_mobile/features/exercise/presentation/screens/exercise_screen.dart';
import 'package:wellform_mobile/features/profile/presentation/screens/profile_screen.dart';
import '../widgets/avatar_popover_button.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ExerciseScreen(),  // tab 0
    ProfileScreen(),   // tab 1
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF073B3A),
        elevation: 0,
        toolbarHeight: 80,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Menu Button
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.menu, color: Colors.tealAccent.withOpacity(0.9)),
                onPressed: () {},
              ),
            ),

            // Avatar popover
            AvatarPopoverButton(
              avatarImageProvider: const NetworkImage(
                'https://primefaces.org/cdn/primeng/images/demo/avatar/amyelsner.png',
              ),
              fullName: 'Nguyễn Văn A',
              email: 'user@example.com',
              onProfile: () => context.go('/profile'),
              onSettings: () => context.go('/settings'),
              onLogout: () {},
            ),
          ],
        ),
      ),

      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: "Bài tập",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Hồ sơ",
          ),
        ],
      ),
    );
  }
}