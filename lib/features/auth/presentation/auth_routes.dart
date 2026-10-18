import 'package:x_ten/core/enums/role.dart';

abstract final class AuthRoutes {
  static const splash = '/splash';
  static const chooseLanguage = '/choose-language';
  static const login = '/login';
  static const signup = '/signup';
  static const verifyOtp = '/verify-otp';
  static const accountType = '/account-type';
  static const forgotPassword = '/forgot-password';
  static const influencerRegistration = '/influencer-registration';
  static const companyRegistration = '/company-registration';

  static String homeFor(Role role) => switch (role) {
        Role.contentCreator => influencerRegistration,
        Role.brand => '/advertiser/home',
        Role.management || Role.unknown => login,
      };

  static String onboardingFor(Role role) => switch (role) {
        Role.brand => companyRegistration,
        _ => influencerRegistration,
      };
}
