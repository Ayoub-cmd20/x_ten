abstract final class ApiEndpoints {
  static const register = '/auth/register/';
  static const verifyPhone = '/auth/verify-phone/';
  static const resendOtp = '/auth/resend-otp/';
  static const selectRole = '/auth/select-role/';
  static const login = '/auth/token/';
  static const refresh = '/auth/refresh/';
  static const passwordResetRequest = '/auth/password-reset/request/';
  static const passwordResetConfirm = '/auth/password-reset/confirm/';

  static const me = '/accounts/me/';
  static const meStatus = '/accounts/me/status/';

  static const registrations = '/influencers/registrations/';
  static String registration(int id) => '$registrations$id/';
  static String submitRegistration(int id) => '${registration(id)}submit/';
  static String profileImage(int id) => '${registration(id)}profile-image/';
  static String socialAccounts(int registrationId) => '${registration(registrationId)}social-accounts/';
  static String socialAccount(int id) => '/influencers/social-accounts/$id/';
  static String portfolio(int registrationId) => '${registration(registrationId)}portfolio/';
  static String portfolioItem(int id) => '/influencers/portfolio/$id/';
  static String documents(int registrationId) => '${registration(registrationId)}documents/';
  static String document(int id) => '/influencers/documents/$id/';

  static const meetings = '/verification/meetings/';
}
