import 'package:x_ten/core/constants/app_constants.dart';

abstract final class Validators {
  static final _algerianMobile = RegExp(r'^(?:\+213|00213|0)[567]\d{8}$');
  static final _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final _digitsOnly = RegExp(r'^\d+$');
  static final _separators = RegExp(r'[\s\-().]');

  static bool isAlgerianMobile(String value) =>
      _algerianMobile.hasMatch(value.replaceAll(_separators, ''));

  static bool isEmail(String value) => _email.hasMatch(value.trim());

  static bool isStrongPassword(String value) =>
      value.length >= 8 && !_digitsOnly.hasMatch(value);

  static bool isOtp(String value) =>
      value.length == AppConstants.otpLength && _digitsOnly.hasMatch(value);
}
