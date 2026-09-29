import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:x_ten/core/localization/localization_extension.dart';

class InfluencerShell extends StatelessWidget {
  final Widget child;

  const InfluencerShell({
    super.key,
    required this.child,
  });

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    if (location.startsWith('/creator/home')) {
      return 0;
    }

    if (location.startsWith('/creator/explore')) {
      return 1;
    }

    if (location.startsWith('/creator/work')) {
      return 2;
    }

    if (location.startsWith('/messages')) {
      return 3;
    }

    if (location.startsWith('/creator/profile')) {
      return 4;
    }

    return 0;
  }

  void _onDestinationSelected(
      BuildContext context,
      int index,
      ) {
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
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex =
    _calculateSelectedIndex(context);

    return Scaffold(
      body: child,

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,

        onDestinationSelected: (index) {
          _onDestinationSelected(
            context,
            index,
          );
        },

        destinations: [
          NavigationDestination(
            icon: const Icon(
              Icons.home_outlined,
            ),
            selectedIcon: const Icon(
              Icons.home_rounded,
            ),
            label: context.l10n.home,
          ),

          NavigationDestination(
            icon: const Icon(
              Icons.explore_outlined,
            ),
            selectedIcon: const Icon(
              Icons.explore_rounded,
            ),
            label: context.l10n.explore,
          ),

          NavigationDestination(
            icon: const Icon(
              Icons.work_outline_rounded,
            ),
            selectedIcon: const Icon(
              Icons.work_rounded,
            ),
            label: context.l10n.work,
          ),

          NavigationDestination(
            icon: const Icon(
              Icons.chat_bubble_outline_rounded,
            ),
            selectedIcon: const Icon(
              Icons.chat_bubble_rounded,
            ),
            label: context.l10n.messages,
          ),

          NavigationDestination(
            icon: const Icon(
              Icons.person_outline_rounded,
            ),
            selectedIcon: const Icon(
              Icons.person_rounded,
            ),
            label: context.l10n.profile,
          ),
        ],
      ),
    );
  }
}