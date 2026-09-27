import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// AUTH
import 'package:x_ten/features/auth/presentation/pages/splash_screen.dart';
import 'package:x_ten/features/auth/presentation/pages/login_screen.dart';

// DASHBOARD
import 'package:x_ten/features/dashboard/presentation/pages/dashboard_screen.dart';

// INFLUENCER
import 'package:x_ten/features/influencer/presentation/widgets/influencer_shell.dart';
import 'package:x_ten/features/influencer/presentation/screens/opportunities_screen.dart';
import 'package:x_ten/features/influencer/presentation/screens/creator_work_screen.dart';
import 'package:x_ten/features/influencer/presentation/screens/conversations_screen.dart';
import 'package:x_ten/features/influencer/presentation/screens/creator_profile_screen.dart';

// INFLUENCER REGISTRATION
import 'package:x_ten/features/influencer_registration/presentation/pages/influencer_registration_screen.dart';
import 'package:x_ten/features/influencer_registration/presentation/pages/registration_submitted_screen.dart';
import 'package:x_ten/features/influencer_registration/presentation/pages/verification_status_screen.dart';
import 'package:x_ten/features/influencer_registration/presentation/pages/verification_meeting_screen.dart';
// freelancer REGESTRATION
import 'package:x_ten/features/freelancer_registration/presentation/pages/freelancer_registration_screen.dart';
import 'package:x_ten/features/freelancer_registration/presentation/pages/registration_submitted_screen.dart';
import 'package:x_ten/features/freelancer_registration/presentation/pages/verification_status_screen.dart';
import 'package:x_ten/features/freelancer_registration/presentation/pages/verification_meeting_screen.dart';
import 'package:x_ten/features/freelancer_registration/presentation/pages/freelancer_dashboard_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',

  routes: [
    // =========================================================
    // SPLASH
    // =========================================================
    GoRoute(
      path: '/splash',
      name: 'splash',
      pageBuilder: (context, state) {
        return MaterialPage<void>(
          key: state.pageKey,
          child: const SplashScreen(),
        );
      },
    ),

    // =========================================================
    // LOGIN
    // =========================================================
    GoRoute(
      path: '/login',
      name: 'login',
      pageBuilder: (context, state) {
        return MaterialPage<void>(
          key: state.pageKey,
          child: const LoginScreen(),
        );
      },
    ),

    // =========================================================
    // INFLUENCER REGISTRATION
    // =========================================================
    GoRoute(
      path: '/influencer-registration',
      name: 'influencerRegistration',
      pageBuilder: (context, state) {
        return MaterialPage<void>(
          key: state.pageKey,
          child: const InfluencerRegistrationScreen(),
        );
      },
    ),

    GoRoute(
      path: '/influencer-registration/submitted',
      name: 'influencerRegistrationSubmitted',
      pageBuilder: (context, state) {
        final registrationId = state.extra as String?;

        return MaterialPage<void>(
          key: state.pageKey,
          child: RegistrationSubmittedScreen(
            registrationId: registrationId ?? 'UNKNOWN',
          ),
        );
      },
    ),

    GoRoute(
      path: '/influencer-verification',
      name: 'influencerVerification',
      pageBuilder: (context, state) {
        final registrationId = state.extra as String?;

        return MaterialPage<void>(
          key: state.pageKey,
          child: VerificationStatusScreen(
            registrationId: registrationId ?? 'UNKNOWN',
          ),
        );
      },
    ),

    GoRoute(
      path: '/influencer-verification/meeting',
      name: 'influencerVerificationMeeting',
      pageBuilder: (context, state) {
        final registrationId = state.extra as String?;

        return MaterialPage<void>(
          key: state.pageKey,
          child: VerificationMeetingScreen(
            registrationId: registrationId ?? 'UNKNOWN',
          ),
        );
      },
    ),
    GoRoute(
        path:'/freelancer-registration',
        builder:(context,state)=>const FreelancerRegistrationScreen()
    ),
    GoRoute(
        path:'/freelancer-registration/submitted',
        builder:(context,state)=>FreelancerRegistrationSubmittedScreen(registrationId:(state.extra as String?)??'UNKNOWN')
    ),
    GoRoute(
        path:'/freelancer-verification',
        builder:(context,state)=>FreelancerVerificationStatusScreen(registrationId:(state.extra as String?)??'UNKNOWN')
    ),
    GoRoute(
        path:'/freelancer-verification/meeting',
        builder:(context,state)=>FreelancerVerificationMeetingScreen(registrationId:(state.extra as String?)??'UNKNOWN')
    ),
    GoRoute(
      path: '/freelancer/home',
      name: 'freelancerHome',
      builder: (context, state) {
        return const FreelancerDashboardScreen();
      },
    ),

    // =========================================================
    // INFLUENCER SHELL
    // =========================================================
    ShellRoute(
      builder: (context, state, child) {
        return InfluencerShell(
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/creator/home',
          name: 'creatorHome',
          pageBuilder: (context, state) {
            return MaterialPage<void>(
              key: state.pageKey,
              child: const DashboardScreen(),
            );
          },
        ),

        GoRoute(
          path: '/creator/explore',
          name: 'creatorExplore',
          pageBuilder: (context, state) {
            return MaterialPage<void>(
              key: state.pageKey,
              child: const OpportunitiesScreen(),
            );
          },
        ),

        GoRoute(
          path: '/creator/work',
          name: 'creatorWork',
          pageBuilder: (context, state) {
            return MaterialPage<void>(
              key: state.pageKey,
              child: const CreatorWorkScreen(),
            );
          },
        ),

        GoRoute(
          path: '/messages',
          name: 'messages',
          pageBuilder: (context, state) {
            return MaterialPage<void>(
              key: state.pageKey,
              child: const ConversationsScreen(),
            );
          },
        ),

        GoRoute(
          path: '/creator/profile',
          name: 'creatorProfile',
          pageBuilder: (context, state) {
            return MaterialPage<void>(
              key: state.pageKey,
              child: const CreatorProfileScreen(),
            );
          },
        ),
      ],
    ),
  ],
);