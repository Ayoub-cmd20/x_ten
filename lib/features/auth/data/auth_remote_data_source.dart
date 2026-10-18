import 'package:x_ten/core/constants/api_endpoints.dart';
import 'package:x_ten/core/constants/api_keys.dart';
import 'package:x_ten/core/enums/role.dart';
import 'package:x_ten/core/network/api_consumer.dart';
import 'package:x_ten/features/auth/data/auth_models.dart';

abstract interface class AuthRemoteDataSource {
  Future<String> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  });

  Future<void> verifyPhone({required String registrationToken, required String otp});

  Future<void> resendOtp(String registrationToken);

  Future<AuthResponseModel> selectRole({required String registrationToken, required Role role});

  Future<AuthResponseModel> login({required String email, required String password});

  Future<void> requestPasswordReset(String phone);

  Future<void> confirmPasswordReset({
    required String phone,
    required String otp,
    required String newPassword,
  });

  Future<UserModel> getMe();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._api);

  final ApiConsumer _api;

  @override
  Future<String> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final data = await _api.post(
      ApiEndpoints.register,
      auth: false,
      data: {
        ApiKeys.fullName: fullName,
        ApiKeys.email: email,
        ApiKeys.phone: phone,
        ApiKeys.password: password,
      },
    );
    return (data as Map<String, dynamic>)[ApiKeys.registrationToken] as String;
  }

  @override
  Future<void> verifyPhone({required String registrationToken, required String otp}) => _api.post(
        ApiEndpoints.verifyPhone,
        auth: false,
        data: {ApiKeys.registrationToken: registrationToken, ApiKeys.otp: otp},
      );

  @override
  Future<void> resendOtp(String registrationToken) => _api.post(
        ApiEndpoints.resendOtp,
        auth: false,
        data: {ApiKeys.registrationToken: registrationToken},
      );

  @override
  Future<AuthResponseModel> selectRole({required String registrationToken, required Role role}) async {
    final data = await _api.post(
      ApiEndpoints.selectRole,
      auth: false,
      data: {ApiKeys.registrationToken: registrationToken, ApiKeys.role: role.name},
    );
    return AuthResponseModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<AuthResponseModel> login({required String email, required String password}) async {
    final data = await _api.post(
      ApiEndpoints.login,
      auth: false,
      data: {ApiKeys.email: email, ApiKeys.password: password},
    );
    return AuthResponseModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> requestPasswordReset(String phone) => _api.post(
        ApiEndpoints.passwordResetRequest,
        auth: false,
        data: {ApiKeys.phone: phone},
      );

  @override
  Future<void> confirmPasswordReset({
    required String phone,
    required String otp,
    required String newPassword,
  }) =>
      _api.post(
        ApiEndpoints.passwordResetConfirm,
        auth: false,
        data: {ApiKeys.phone: phone, ApiKeys.otp: otp, ApiKeys.newPassword: newPassword},
      );

  @override
  Future<UserModel> getMe() async {
    final data = await _api.get(ApiEndpoints.me);
    return UserModel.fromJson(data as Map<String, dynamic>);
  }
}
