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
  static String ccpCheque(int registrationId) => '${financialAccounts(registrationId)}ccp-cheque/';
  static String portfolio(int registrationId) => '${registration(registrationId)}portfolio/';
  static String portfolioItem(int id) => '/influencers/portfolio/$id/';
  static String documents(int registrationId) => '${registration(registrationId)}documents/';
  static String document(int id) => '/influencers/documents/$id/';

  static const meetings = '/verification/meetings/';

  static const companyProfile = '/companies/profile/';
  static const companySubmit = '/companies/profile/submit/';
  static const companyDocuments = '/companies/profile/documents/';
  static String companyDocument(int id) => '/companies/documents/$id/';

  static const marketplaceInfluencers = '/marketplace/influencers/';
  static String marketplaceInfluencer(int id) => '$marketplaceInfluencers$id/';

  static const adRequests = '/campaigns/ad-requests/';
  static String adRequest(int id) => '$adRequests$id/';
  static String adRequestSubmit(int id) => '${adRequest(id)}submit/';
  static String adRequestReject(int id) => '${adRequest(id)}reject/';
  static String adRequestEvents(int id) => '${adRequest(id)}events/';
  static String adRequestAcceptModification(int id) => '${adRequest(id)}accept-modification/';
  static String adRequestRefuseModification(int id) => '${adRequest(id)}refuse-modification/';
  static String adRequestAttachments(int id) => '${adRequest(id)}attachments/';
  static String adRequestAttachment(int id) => '${adRequests}attachments/$id/';

  static const influencerRequests = '/campaigns/influencer/ad-requests/';
  static const influencerRequestTabs = '${influencerRequests}tabs/';
  static String influencerRequest(int id) => '$influencerRequests$id/';
  static String influencerRequestEvents(int id) => '${influencerRequest(id)}events/';
  static String influencerRequestAccept(int id) => '${influencerRequest(id)}accept/';
  static String influencerRequestCounterOffer(int id) => '${influencerRequest(id)}counter-offer/';
  static String influencerRequestUnclear(int id) => '${influencerRequest(id)}unclear/';
  static String influencerRequestDecline(int id) => '${influencerRequest(id)}decline/';
}
