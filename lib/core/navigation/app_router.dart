import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:x_ten/core/di/injection_container.dart';
import 'package:x_ten/core/navigation/app_page.dart';
import 'package:x_ten/features/auth/presentation/auth_routes.dart';
import 'package:x_ten/features/auth/presentation/pages/account_type_page.dart';
import 'package:x_ten/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:x_ten/features/auth/presentation/pages/language_page.dart';
import 'package:x_ten/features/auth/presentation/pages/login_page.dart';
import 'package:x_ten/features/auth/presentation/pages/otp_page.dart';
import 'package:x_ten/features/auth/presentation/pages/signup_page.dart';
import 'package:x_ten/features/auth/presentation/pages/splash_page.dart';
import 'package:x_ten/features/company_profile/presentation/company_cubit.dart';
import 'package:x_ten/features/company_profile/presentation/company_pages.dart';
import 'package:x_ten/features/company_profile/presentation/company_routes.dart';
import 'package:x_ten/features/home/presentation/pages/home_page.dart';
import 'package:x_ten/features/influencer_registration/presentation/pages/registration_gate_page.dart';
import 'package:x_ten/features/influencer_registration/presentation/pages/registration_optional_page.dart';
import 'package:x_ten/features/influencer_registration/presentation/pages/registration_status_page.dart';
import 'package:x_ten/features/influencer_registration/presentation/pages/registration_wizard_page.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_routes.dart';
import 'package:x_ten/features/onboarding/presentation/onboarding_routes.dart';
import 'package:x_ten/features/onboarding/presentation/pages/onboarding_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AuthRoutes.splash,
  routes: [
    GoRoute(
      path: AuthRoutes.splash,
      name: 'splash',
      pageBuilder: (context, state) => appPage(state, const SplashPage()),
    ),
    GoRoute(
      path: AuthRoutes.chooseLanguage,
      name: 'chooseLanguage',
      pageBuilder: (context, state) => appPage(state, const LanguagePage()),
    ),
    GoRoute(
      path: OnboardingRoutes.onboarding,
      name: 'onboarding',
      pageBuilder: (context, state) => appPage(state, const OnboardingPage()),
    ),
    GoRoute(
      path: AuthRoutes.login,
      name: 'login',
      pageBuilder: (context, state) => appPage(state, const LoginPage()),
    ),
    GoRoute(
      path: AuthRoutes.signup,
      name: 'signup',
      pageBuilder: (context, state) => appPage(state, const SignupPage()),
    ),
    GoRoute(
      path: AuthRoutes.forgotPassword,
      name: 'forgotPassword',
      pageBuilder: (context, state) => appPage(state, const ForgotPasswordPage()),
    ),
    GoRoute(
      path: AuthRoutes.verifyOtp,
      name: 'verifyOtp',
      pageBuilder: (context, state) => appPage(state, const OtpPage()),
    ),
    GoRoute(
      path: AuthRoutes.accountType,
      name: 'accountType',
      pageBuilder: (context, state) => appPage(state, const AccountTypePage()),
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
          pageBuilder: (context, state) => appPage(state, const CompanyGatePage()),
        ),
        GoRoute(
          path: CompanyRoutes.form,
          name: 'companyRegistrationForm',
          pageBuilder: (context, state) => appPage(state, const CompanyWizardPage()),
        ),
        GoRoute(
          path: CompanyRoutes.status,
          name: 'companyRegistrationStatus',
          pageBuilder: (context, state) => appPage(state, const CompanyStatusPage()),
        ),
      ],
    ),
    ShellRoute(
      builder: (context, state, child) => BlocProvider(
        create: (_) => sl<RegistrationCubit>(),
        child: child,
      ),
      routes: [
        GoRoute(
          path: RegistrationRoutes.gate,
          name: 'influencerRegistration',
          pageBuilder: (context, state) => appPage(state, const RegistrationGatePage()),
        ),
        GoRoute(
          path: RegistrationRoutes.form,
          name: 'influencerRegistrationForm',
          pageBuilder: (context, state) => appPage(state, const RegistrationWizardPage()),
        ),
        GoRoute(
          path: RegistrationRoutes.status,
          name: 'influencerRegistrationStatus',
          pageBuilder: (context, state) => appPage(state, const RegistrationStatusPage()),
        ),
        GoRoute(
          path: RegistrationRoutes.optional,
          name: 'influencerRegistrationOptional',
          pageBuilder: (context, state) => appPage(state, const RegistrationOptionalPage()),
        ),
      ],
    ),
    GoRoute(
      path: CompanyRoutes.advertiserHome,
      name: 'advertiserHome',
      pageBuilder: (context, state) => appPage(state, const HomePage()),
    ),
    GoRoute(
      path: RegistrationRoutes.creatorHome,
      name: 'creatorHome',
      pageBuilder: (context, state) => appPage(state, const HomePage()),
    ),
  ],
);
