import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InfluencerShell extends StatelessWidget {
  final Widget child;

  const InfluencerShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        backgroundColor: const Color(0xFF0A0A0A),
        indicatorColor: const Color(0xFFE2C044).withValues(alpha:0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Colors.white70),
            selectedIcon: Icon(Icons.home, color: Color(0xFFE2C044)),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined, color: Colors.white70),
            selectedIcon: Icon(Icons.explore, color: Color(0xFFE2C044)),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.work_outline, color: Colors.white70),
            selectedIcon: Icon(Icons.work, color: Color(0xFFE2C044)),
            label: 'Work',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline, color: Colors.white70),
            selectedIcon: Icon(Icons.chat_bubble, color: Color(0xFFE2C044)),
            label: 'Messages',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: Colors.white70),
            selectedIcon: Icon(Icons.person, color: Color(0xFFE2C044)),
            label: 'Profile',
          ),
        ],
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/creator/home');
              break;
            case 1:
              context.go('/creator/explore');
              break;
            case 2:
              context.go('/creator/work');
              break;
            case 3:
              context.go('/messages');
              break;
            case 4:
              context.go('/creator/profile');
              break;
          }
        },
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/creator/explore')) return 1;
    if (location.startsWith('/creator/work')) return 2;
    if (location.startsWith('/messages')) return 3;
    if (location.startsWith('/creator/profile')) return 4;

    return 0;
  }
}
