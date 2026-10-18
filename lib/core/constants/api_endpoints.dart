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
}
