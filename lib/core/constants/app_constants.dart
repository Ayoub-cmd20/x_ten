abstract final class AppConstants {
  static const connectTimeout = Duration(seconds: 30);
  static const receiveTimeout = Duration(seconds: 90);
  static const pageSize = 20;
  static const otpLength = 6;
  static const otpResendCooldown = Duration(seconds: 60);
}
