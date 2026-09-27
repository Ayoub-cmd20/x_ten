import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FreelancerShell extends StatelessWidget {
  final Widget child;

  const FreelancerShell({
    super.key,
    required this.child,
  });

  static const Color _gold = Color(0xFFE5C158);
  static const Color _background = Color(0xFF0A0A0A);
  static const Color _surface = Color(0xFF111111);

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    if (location.startsWith('/freelancer/explore')) {
      return 1;
    }

    if (location.startsWith('/freelancer/work')) {
      return 2;
    }

    if (location.startsWith('/freelancer/messages')) {
      return 3;
    }

    if (location.startsWith('/freelancer/profile')) {
      return 4;
    }

    return 0;
  }

  void _navigate(
      BuildContext context,
      int index,
      ) {
    switch (index) {
      case 0:
        context.go('/freelancer/home');
        break;

      case 1:
        context.go('/freelancer/explore');
        break;

      case 2:
        context.go('/freelancer/work');
        break;

      case 3:
        context.go('/freelancer/messages');
        break;

      case 4:
        context.go('/freelancer/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _selectedIndex(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _background,

        body: child,

        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          backgroundColor: _surface,
          indicatorColor: _gold.withValues(
            alpha: 0.18,
          ),
          onDestinationSelected: (index) {
            _navigate(
              context,
              index,
            );
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(
                Icons.home_outlined,
              ),
              selectedIcon: Icon(
                Icons.home_rounded,
                color: _gold,
              ),
              label: 'الرئيسية',
            ),

            NavigationDestination(
              icon: Icon(
                Icons.explore_outlined,
              ),
              selectedIcon: Icon(
                Icons.explore_rounded,
                color: _gold,
              ),
              label: 'الفرص',
            ),

            NavigationDestination(
              icon: Icon(
                Icons.work_outline,
              ),
              selectedIcon: Icon(
                Icons.work_rounded,
                color: _gold,
              ),
              label: 'مشاريعي',
            ),

            NavigationDestination(
              icon: Icon(
                Icons.chat_bubble_outline,
              ),
              selectedIcon: Icon(
                Icons.chat_bubble_rounded,
                color: _gold,
              ),
              label: 'الرسائل',
            ),

            NavigationDestination(
              icon: Icon(
                Icons.person_outline,
              ),
              selectedIcon: Icon(
                Icons.person_rounded,
                color: _gold,
              ),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }
}