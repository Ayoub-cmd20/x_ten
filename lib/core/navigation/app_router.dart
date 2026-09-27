import 'package:go_router/go_router.dart';
import 'package:x_ten/features/onboarding/presentation/pages/onboarding_screen.dart';
// ============================================================
// AUTH
// ============================================================

import 'package:x_ten/features/auth/presentation/pages/splash_screen.dart';
import 'package:x_ten/features/auth/presentation/pages/login_screen.dart';

// ============================================================
// INFLUENCER DASHBOARD
// ============================================================

import 'package:x_ten/features/dashboard/presentation/pages/dashboard_screen.dart';

// ============================================================
// INFLUENCER APP
// ============================================================

import 'package:x_ten/features/influencer/presentation/widgets/influencer_shell.dart';
import 'package:x_ten/features/influencer/presentation/screens/opportunities_screen.dart';
import 'package:x_ten/features/influencer/presentation/screens/creator_work_screen.dart';
import 'package:x_ten/features/influencer/presentation/screens/conversations_screen.dart';
import 'package:x_ten/features/influencer/presentation/screens/creator_profile_screen.dart';

// ============================================================
// INFLUENCER REGISTRATION
// ============================================================

import 'package:x_ten/features/influencer_registration/presentation/pages/influencer_registration_screen.dart';
import 'package:x_ten/features/influencer_registration/presentation/pages/registration_submitted_screen.dart';
import 'package:x_ten/features/influencer_registration/presentation/pages/verification_status_screen.dart';
import 'package:x_ten/features/influencer_registration/presentation/pages/verification_meeting_screen.dart';

// ============================================================
// FREELANCER REGISTRATION
// ============================================================

import 'package:x_ten/features/freelancer_registration/presentation/pages/freelancer_registration_screen.dart';

import 'package:x_ten/features/freelancer_registration/presentation/pages/registration_submitted_screen.dart'
as freelancer_submitted;

import 'package:x_ten/features/freelancer_registration/presentation/pages/verification_status_screen.dart'
as freelancer_verification;

import 'package:x_ten/features/freelancer_registration/presentation/pages/verification_meeting_screen.dart'
as freelancer_meeting;

import 'package:x_ten/features/freelancer_registration/presentation/pages/freelancer_dashboard_screen.dart';

// ============================================================
// FREELANCER APP
// ============================================================

import 'package:x_ten/features/freelancer/presentation/widgets/freelancer_shell.dart';
import 'package:x_ten/features/freelancer/presentation/screens/freelancer_opportunities_screen.dart';
import 'package:x_ten/features/freelancer/presentation/screens/freelancer_work_screen.dart';
import 'package:x_ten/features/freelancer/presentation/screens/freelancer_profile_screen.dart';
import 'package:x_ten/features/influencer/presentation/screens/opportunity_details_screen.dart';
import 'package:x_ten/features/influencer/presentation/screens/creator_project_details_screen.dart';
import 'package:x_ten/features/influencer/presentation/screens/creator_portfolio_screen.dart';
import 'package:x_ten/features/influencer/presentation/screens/creator_settings_screen.dart';
// ============================================================
// ROUTER
// ============================================================

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',

  routes: [
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (
          context,
          state,
          ) {
        return const OnboardingScreen();
      },
    ),
    // =========================================================
    // SPLASH
    // =========================================================

    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) {
        return const SplashScreen();
      },
    ),

    // =========================================================
    // LOGIN
    // =========================================================

    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) {
        return const LoginScreen();
      },
    ),

    // =========================================================
    // INFLUENCER REGISTRATION
    // =========================================================

    GoRoute(
      path: '/influencer-registration',
      name: 'influencerRegistration',
      builder: (context, state) {
        return const InfluencerRegistrationScreen();
      },
    ),

    GoRoute(
      path: '/influencer-registration/submitted',
      name: 'influencerRegistrationSubmitted',
      builder: (context, state) {
        final registrationId =
        state.extra as String?;

        return RegistrationSubmittedScreen(
          registrationId:
          registrationId ?? 'UNKNOWN',
        );
      },
    ),

    GoRoute(
      path: '/influencer-verification',
      name: 'influencerVerification',
      builder: (context, state) {
        final registrationId =
        state.extra as String?;

        return VerificationStatusScreen(
          registrationId:
          registrationId ?? 'UNKNOWN',
        );
      },
    ),

    GoRoute(
      path: '/influencer-verification/meeting',
      name: 'influencerVerificationMeeting',
      builder: (context, state) {
        final registrationId =
        state.extra as String?;

        return VerificationMeetingScreen(
          registrationId:
          registrationId ?? 'UNKNOWN',
        );
      },
    ),

    // =========================================================
    // FREELANCER REGISTRATION
    // =========================================================

    GoRoute(
      path: '/freelancer-registration',
      name: 'freelancerRegistration',
      builder: (context, state) {
        return const FreelancerRegistrationScreen();
      },
    ),

    GoRoute(
      path: '/freelancer-registration/submitted',
      name: 'freelancerRegistrationSubmitted',
      builder: (context, state) {
        final registrationId =
        state.extra as String?;

        return freelancer_submitted
            .FreelancerRegistrationSubmittedScreen(
          registrationId:
          registrationId ?? 'UNKNOWN',
        );
      },
    ),

    GoRoute(
      path: '/freelancer-verification',
      name: 'freelancerVerification',
      builder: (context, state) {
        final registrationId =
        state.extra as String?;

        return freelancer_verification
            .FreelancerVerificationStatusScreen(
          registrationId:
          registrationId ?? 'UNKNOWN',
        );
      },
    ),

    GoRoute(
      path: '/freelancer-verification/meeting',
      name: 'freelancerVerificationMeeting',
      builder: (context, state) {
        final registrationId =
        state.extra as String?;

        return freelancer_meeting
            .FreelancerVerificationMeetingScreen(
          registrationId:
          registrationId ?? 'UNKNOWN',
        );
      },
    ),

    // =========================================================
    // FREELANCER SHELL
    // =========================================================

    ShellRoute(
      builder: (
          context,
          state,
          child,
          ) {
        return FreelancerShell(
          child: child,
        );
      },

      routes: [
        GoRoute(
          path: '/freelancer/home',
          name: 'freelancerHome',
          builder: (
              context,
              state,
              ) {
            return const FreelancerDashboardScreen();
          },
        ),

        GoRoute(
          path: '/freelancer/explore',
          name: 'freelancerExplore',
          builder: (
              context,
              state,
              ) {
            return const FreelancerOpportunitiesScreen();
          },
        ),

        GoRoute(
          path: '/freelancer/work',
          name: 'freelancerWork',
          builder: (
              context,
              state,
              ) {
            return const FreelancerWorkScreen();
          },
        ),

        GoRoute(
          path: '/freelancer/messages',
          name: 'freelancerMessages',
          builder: (
              context,
              state,
              ) {
            return const ConversationsScreen();
          },
        ),

        GoRoute(
          path: '/freelancer/profile',
          name: 'freelancerProfile',
          builder: (
              context,
              state,
              ) {
            return const FreelancerProfileScreen();
          },
        ),
      ],
    ),

    // =========================================================
    // INFLUENCER SHELL
    // =========================================================

    ShellRoute(
      builder: (
          context,
          state,
          child,
          ) {
        return InfluencerShell(
          child: child,
        );
      },

      routes: [
        GoRoute(
          path: '/creator/home',
          name: 'creatorHome',
          builder: (
              context,
              state,
              ) {
            return const DashboardScreen();
          },
        ),

        GoRoute(
          path: '/creator/explore',
          name: 'creatorExplore',
          builder: (
              context,
              state,
              ) {
            return const OpportunitiesScreen();
          },
        ),

        GoRoute(
          path: '/creator/work',
          name: 'creatorWork',
          builder: (
              context,
              state,
              ) {
            return const CreatorWorkScreen();
          },
        ),

        GoRoute(
          path: '/messages',
          name: 'messages',
          builder: (
              context,
              state,
              ) {
            return const ConversationsScreen();
          },
        ),

        GoRoute(
          path: '/creator/profile',
          name: 'creatorProfile',
          builder: (
              context,
              state,
              ) {
            return const CreatorProfileScreen();
          },
        ),
      ],
    ),
    // =========================================================
// CREATOR SECONDARY SCREENS
// =========================================================

    GoRoute(
      path: '/creator/opportunity-details',
      name: 'creatorOpportunityDetails',
      builder: (
          context,
          state,
          ) {
        final data =
            (state.extra
            as Map<String, dynamic>?) ??
                {};

        return OpportunityDetailsScreen(
          title:
          data['title'] as String? ??
              'Opportunity',

          brand:
          data['brand'] as String? ??
              'Brand',

          category:
          data['category'] as String? ??
              '',

          budget:
          data['budget'] as String? ??
              '',

          deadline:
          data['deadline'] as String? ??
              '',

          description:
          data['description']
          as String? ??
              '',

          type:
          data['type'] as String? ??
              '',

          platforms:
          List<String>.from(
            data['platforms']
            as List? ??
                const [],
          ),
        );
      },
    ),

    GoRoute(
      path: '/creator/project-details',
      name: 'creatorProjectDetails',
      builder: (
          context,
          state,
          ) {
        final data =
            (state.extra
            as Map<String, dynamic>?) ??
                {};

        return CreatorProjectDetailsScreen(
          title:
          data['title'] as String? ??
              'Project',

          brand:
          data['brand'] as String? ??
              'Brand',

          status:
          data['status'] as String? ??
              '',

          progress:
          (data['progress'] as num?)
              ?.toDouble() ??
              0,

          deadline:
          data['deadline'] as String? ??
              '',

          amount:
          data['amount'] as String? ??
              '',

          deliverables:
          data['deliverables']
          as String? ??
              '',
        );
      },
    ),

    GoRoute(
      path: '/creator/portfolio',
      name: 'creatorPortfolio',
      builder: (
          context,
          state,
          ) {
        return const CreatorPortfolioScreen();
      },
    ),

    GoRoute(
      path: '/creator/settings',
      name: 'creatorSettings',
      builder: (
          context,
          state,
          ) {
        return const CreatorSettingsScreen();
      },
    ),
  ],
);