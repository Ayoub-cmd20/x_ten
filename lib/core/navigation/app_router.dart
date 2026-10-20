import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/di/injection_container.dart';
import 'package:x_ten/features/influencer_registration/presentation/pages/registration_gate_page.dart';
import 'package:x_ten/features/influencer_registration/presentation/pages/registration_optional_page.dart';
import 'package:x_ten/features/influencer_registration/presentation/pages/registration_status_page.dart';
import 'package:x_ten/features/influencer_registration/presentation/pages/registration_wizard_page.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_routes.dart';
import 'package:x_ten/features/auth/presentation/pages/splash_page.dart';
import 'package:x_ten/features/auth/presentation/pages/login_page.dart';
import 'package:x_ten/features/auth/presentation/pages/signup_page.dart';
import 'package:x_ten/features/auth/presentation/pages/otp_page.dart';
import 'package:x_ten/features/auth/presentation/pages/account_type_page.dart';
import 'package:x_ten/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:x_ten/features/company_profile/presentation/company_cubit.dart';
import 'package:x_ten/features/marketplace/presentation/marketplace_cubit.dart';
import 'package:x_ten/features/company_profile/presentation/company_pages.dart';
import 'package:x_ten/features/company_profile/presentation/company_routes.dart';
import 'package:x_ten/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:x_ten/features/settings_security/presentation/pages/language_screen.dart';
import 'package:x_ten/features/saved_items/presentation/pages/saved_items_screen.dart';
import 'package:x_ten/features/contracts_agreements/presentation/pages/contracts_screen.dart';
import 'package:x_ten/features/settings_security/presentation/pages/financial_security_screen.dart';
import 'package:x_ten/features/settings_security/presentation/pages/settings_screen.dart';
// ============================================================
// AUTH
// ============================================================


// ============================================================
// INFLUENCER DASHBOARD
// ============================================================

import 'package:x_ten/features/dashboard/presentation/pages/dashboard_screen.dart';

// ============================================================
// INFLUENCER APP
// ============================================================

import 'package:x_ten/features/influencer/presentation/widgets/influencer_shell.dart';
import 'package:x_ten/features/campaigns/presentation/pages/influencer/opportunities_screen.dart';
import 'package:x_ten/features/campaigns/presentation/pages/influencer/creator_work_screen.dart';
import 'package:x_ten/features/influencer/presentation/screens/conversations_screen.dart';
import 'package:x_ten/features/influencer/presentation/screens/creator_profile_screen.dart';

// ============================================================
// INFLUENCER REGISTRATION
// ============================================================


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
import 'package:x_ten/features/campaigns/presentation/pages/influencer/opportunity_details_screen.dart';
import 'package:x_ten/features/campaigns/presentation/pages/influencer/creator_project_details_screen.dart';
import 'package:x_ten/features/influencer_registration/presentation/pages/creator_portfolio_screen.dart';
import 'package:x_ten/features/influencer/presentation/screens/creator_settings_screen.dart';

// ============================================================
// ADVERTISER APP
// ============================================================

import 'package:x_ten/features/advertiser/presentation/widgets/advertiser_shell.dart';
import 'package:x_ten/features/advertiser/presentation/pages/advertiser_dashboard_screen.dart';
import 'package:x_ten/features/marketplace/presentation/pages/advertiser_explore_screen.dart';
import 'package:x_ten/features/company_profile/presentation/pages/advertiser_profile_screen.dart';
import 'package:x_ten/features/company_profile/presentation/pages/edit_brand_profile_screen.dart';
import 'package:x_ten/features/marketplace/presentation/pages/influencer_categories_screen.dart';
import 'package:x_ten/features/marketplace/presentation/pages/influencer_details_screen.dart';
import 'package:x_ten/features/campaigns/presentation/pages/client/campaign_creation_screen.dart';
import 'package:x_ten/features/campaigns/presentation/pages/client/my_campaigns_screen.dart';
import 'package:x_ten/features/campaigns/presentation/pages/client/ad_request_details_screen.dart';
import 'package:x_ten/features/campaigns/presentation/ad_requests_cubit.dart';
import 'package:x_ten/features/campaigns/presentation/influencer_requests_cubit.dart';

// ============================================================
// PROMOTION (ADVERTISER)
// ============================================================

import 'package:x_ten/features/campaigns/presentation/pages/client/on_demand_promotion_screen.dart';
import 'package:x_ten/features/campaigns/presentation/pages/client/my_promotion_requests_screen.dart';

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
    GoRoute(
      path: '/settings/language',
      name: 'language',

      builder: (
          context,
          state,
          ) {
        return const LanguageScreen();
      },
    ),
    GoRoute(
      path: '/settings/financial-security',
      name: 'financialSecurity',
      builder: (context, state) => const FinancialSecurityScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/saved-items',
      name: 'savedItems',
      builder: (context, state) => const SavedItemsScreen(),
    ),
    GoRoute(
      path: '/contracts',
      name: 'contracts',
      builder: (context, state) => const ContractsScreen(),
    ),
    GoRoute(
      path: '/choose-language',
      name: 'chooseLanguage',

      builder: (
          context,
          state,
          ) {
        return const LanguageScreen();
      },
    ),
    // =========================================================
    // SPLASH
    // =========================================================

    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) {
        return const SplashPage();
      },
    ),

    // =========================================================
    // LOGIN
    // =========================================================

    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),

    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => const SignupPage(),
    ),

    GoRoute(
      path: '/forgot-password',
      name: 'forgotPassword',
      builder: (context, state) => const ForgotPasswordPage(),
    ),

    GoRoute(
      path: '/verify-otp',
      name: 'verifyOtp',
      builder: (context, state) => const OtpPage(),
    ),

    GoRoute(
      path: '/account-type',
      name: 'accountType',
      builder: (context, state) => const AccountTypePage(),
    ),

    ShellRoute(
      builder: (context, state, child) => BlocProvider(
        create: (_) => sl<CompanyCubit>(),
        child: child,
      ),
      routes: [
        GoRoute(
          path: CompanyRoutes.gate,
          name: 'companyRegistration',
          builder: (context, state) => const CompanyGatePage(),
        ),
        GoRoute(
          path: CompanyRoutes.form,
          name: 'companyRegistrationForm',
          builder: (context, state) => const CompanyWizardPage(),
        ),
        GoRoute(
          path: CompanyRoutes.status,
          name: 'companyRegistrationStatus',
          builder: (context, state) => const CompanyStatusPage(),
        ),
      ],
    ),

    // =========================================================
    // INFLUENCER REGISTRATION
    // =========================================================

    ShellRoute(
      builder: (context, state, child) => BlocProvider(
        create: (_) => sl<RegistrationCubit>(),
        child: child,
      ),
      routes: [
        GoRoute(
          path: RegistrationRoutes.gate,
          name: 'influencerRegistration',
          builder: (context, state) => const RegistrationGatePage(),
        ),
        GoRoute(
          path: RegistrationRoutes.form,
          name: 'influencerRegistrationForm',
          builder: (context, state) => const RegistrationWizardPage(),
        ),
        GoRoute(
          path: RegistrationRoutes.status,
          name: 'influencerRegistrationStatus',
          builder: (context, state) => const RegistrationStatusPage(),
        ),
        GoRoute(
          path: RegistrationRoutes.optional,
          name: 'influencerRegistrationOptional',
          builder: (context, state) => const RegistrationOptionalPage(),
        ),
      ],
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
            return BlocProvider(
              create: (_) => sl<InfluencerRequestsCubit>(),
              child: const OpportunitiesScreen(),
            );
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
        final extra = state.extra;
        final preview = extra is AdRequest ? extra : null;
        final requestId = switch (extra) {
          AdRequest(:final id) => id,
          final int id => id,
          _ => 0,
        };

        return BlocProvider(
          create: (_) => sl<InfluencerRequestsCubit>(),
          child: OpportunityDetailsScreen(
            requestId: requestId,
            preview: preview,
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

    // =========================================================
    // ADVERTISER SHELL
    // =========================================================

    ShellRoute(
      builder: (
          context,
          state,
          child,
          ) {
        return AdvertiserShell(
          child: child,
        );
      },

      routes: [
        GoRoute(
          path: '/advertiser/home',
          name: 'advertiserHome',
          builder: (
              context,
              state,
              ) {
            return const AdvertiserDashboardScreen();
          },
        ),

        GoRoute(
          path: '/advertiser/explore',
          name: 'advertiserExplore',
          builder: (
              context,
              state,
              ) {
            final categoryId =
            state.uri.queryParameters['category'];

            return BlocProvider(
              create: (_) => sl<MarketplaceCubit>(),
              child: AdvertiserExploreScreen(
                categoryId: categoryId,
              ),
            );
          },
        ),

        GoRoute(
          path: '/advertiser/promotion',
          name: 'advertiserPromotion',
          builder: (
              context,
              state,
              ) {
            return BlocProvider(
              create: (_) => sl<AdRequestsCubit>(),
              child: const MyCampaignsScreen(),
            );
          },
        ),

        GoRoute(
          path: '/advertiser/messages',
          name: 'advertiserMessages',
          builder: (
              context,
              state,
              ) {
            return const ConversationsScreen();
          },
        ),

        GoRoute(
          path: '/advertiser/profile',
          name: 'advertiserProfile',
          builder: (
              context,
              state,
              ) {
            return const AdvertiserProfileScreen();
          },
        ),
      ],
    ),

    // =========================================================
    // ADVERTISER SECONDARY SCREENS
    // =========================================================

    GoRoute(
      path: '/advertiser/profile/edit',
      name: 'advertiserProfileEdit',
      builder: (
        context,
        state,
      ) {
        final extra = state.extra as Map<String, dynamic>?;
        return EditBrandProfileScreen(
          initialBrandName: extra?['brandName'] as String? ?? 'اسم العلامة التجارية',
          initialEmail: extra?['email'] as String? ?? 'brand@example.com',
          initialCategory: extra?['category'] as String? ?? 'التجارة الإلكترونية',
          initialPhone: extra?['phone'] as String? ?? '+966 50 123 4567',
          initialBio: extra?['bio'] as String? ?? 'علامة تجارية متخصصة في تقديم أحدث المنتجات والتجارب المبتكرة.',
          initialWebsite: extra?['website'] as String? ?? 'https://brand.example.com',
          initialLocation: extra?['location'] as String? ?? 'الرياض، المملكة العربية السعودية',
        );
      },
    ),

    GoRoute(
      path: '/advertiser/influencers',
      name: 'advertiserInfluencers',
      builder: (
          context,
          state,
          ) {
        final categoryId =
        state.uri.queryParameters['category'];

        return BlocProvider(
          create: (_) => sl<MarketplaceCubit>(),
          child: AdvertiserExploreScreen(
            categoryId: categoryId,
          ),
        );
      },
    ),

    GoRoute(
      path: '/advertiser/categories',
      name: 'advertiserCategories',
      builder: (
          context,
          state,
          ) {
        return const InfluencerCategoriesScreen();
      },
    ),

    GoRoute(
      path: '/advertiser/influencer-details',
      name: 'advertiserInfluencerDetails',
      builder: (
          context,
          state,
          ) {
        final extra = state.extra;
        final preview = extra is MarketInfluencer ? extra : null;
        final influencerId = switch (extra) {
          MarketInfluencer(:final id) => id,
          final int id => id,
          final String id => int.tryParse(id) ?? 0,
          _ => 0,
        };

        return BlocProvider(
          create: (_) => sl<MarketplaceCubit>(),
          child: InfluencerDetailsScreen(
            influencerId: influencerId,
            preview: preview,
          ),
        );
      },
    ),

    GoRoute(
      path: '/advertiser/campaign/new',
      name: 'advertiserCampaignNew',
      builder: (
          context,
          state,
          ) {
        final influencer = state.extra;

        return BlocProvider(
          create: (_) => sl<AdRequestsCubit>(),
          child: CampaignCreationScreen(
            influencer: influencer is MarketInfluencer ? influencer : null,
          ),
        );
      },
    ),

    GoRoute(
      path: '/advertiser/campaigns',
      name: 'advertiserCampaigns',
      builder: (
          context,
          state,
          ) {
        return BlocProvider(
          create: (_) => sl<AdRequestsCubit>(),
          child: const MyCampaignsScreen(),
        );
      },
    ),

    GoRoute(
      path: '/advertiser/campaigns/details',
      name: 'advertiserCampaignDetails',
      builder: (
          context,
          state,
          ) {
        final extra = state.extra;
        final preview = extra is AdRequest ? extra : null;
        final requestId = switch (extra) {
          AdRequest(:final id) => id,
          final int id => id,
          _ => 0,
        };

        return BlocProvider(
          create: (_) => sl<AdRequestsCubit>(),
          child: AdRequestDetailsScreen(
            requestId: requestId,
            preview: preview,
          ),
        );
      },
    ),

    GoRoute(
      path: '/advertiser/promotion/on-demand',
      name: 'advertiserOnDemandPromotion',
      builder: (
          context,
          state,
          ) {
        return const OnDemandPromotionScreen();
      },
    ),

    GoRoute(
      path: '/advertiser/promotion/requests',
      name: 'advertiserPromotionRequests',
      builder: (
          context,
          state,
          ) {
        return const MyPromotionRequestsScreen();
      },
    ),
  ],
);
