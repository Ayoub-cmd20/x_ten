import 'package:go_router/go_router.dart';
import 'package:x_ten/features/auth/presentation/pages/splash_screen.dart';
import 'package:x_ten/features/auth/presentation/pages/login_screen.dart';
import 'package:x_ten/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:x_ten/features/influencer/presentation/widgets/influencer_shell.dart';
import 'package:x_ten/features/influencer/presentation/screens/opportunities_screen.dart';
import 'package:x_ten/features/influencer/presentation/screens/creator_work_screen.dart';
import 'package:x_ten/features/influencer/presentation/screens/conversations_screen.dart';
import 'package:x_ten/features/influencer/presentation/screens/creator_profile_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => InfluencerShell(child: child),
      routes: [
        GoRoute(
          path: '/creator/home',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/creator/explore',
          builder: (context, state) => const OpportunitiesScreen(),
        ),
        GoRoute(
          path: '/creator/work',
          builder: (context, state) => const CreatorWorkScreen(),
        ),
        GoRoute(
          path: '/messages',
          builder: (context, state) => const ConversationsScreen(),
        ),
        GoRoute(
          path: '/creator/profile',
          builder: (context, state) => const CreatorProfileScreen(),
        ),
      ],
    ),
  ],
);
