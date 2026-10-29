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
  static String refreshSocialAccount(int id) => '${socialAccount(id)}refresh/';
  static String socialScreenshot(int id) => '${socialAccount(id)}screenshot/';
  static String audienceScreenshots(int registrationId) => '${registration(registrationId)}audience-screenshots/';
  static String financialAccounts(int registrationId) => '${registration(registrationId)}financial-accounts/';
  static String financialAccount(int id) => '/influencers/financial-accounts/$id/';
  static String financialRead(int registrationId) => '${financialAccounts(registrationId)}read/';
  static String portfolio(int registrationId) => '${registration(registrationId)}portfolio/';
  static String portfolioItem(int id) => '/influencers/portfolio/$id/';
  static String documents(int registrationId) => '${registration(registrationId)}documents/';
  static String document(int id) => '/influencers/documents/$id/';

  static const meetings = '/verification/meetings/';

  static const companyProfile = '/companies/profile/';
  static const companySubmit = '/companies/profile/submit/';
  static const companyDocuments = '/companies/profile/documents/';
  static const companyImage = '/companies/profile/image/';
  static const companyFinancialAccounts = '/companies/profile/financial-accounts/';
  static const companyFinancialRead = '${companyFinancialAccounts}read/';
  static const companyMarketingRead = '/companies/profile/marketing-pages/read/';
  static String companyDocument(int id) => '/companies/documents/$id/';
  static String companyFinancialAccount(int id) => '/companies/financial-accounts/$id/';
}
