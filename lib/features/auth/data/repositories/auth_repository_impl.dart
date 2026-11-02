import 'package:x_ten/core/enums/role.dart';
import 'package:x_ten/core/storage/token_storage.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:x_ten/features/auth/data/models/auth_response_model.dart';
import 'package:x_ten/features/auth/domain/entities/auth_session.dart';
import 'package:x_ten/features/auth/domain/entities/user.dart';
import 'package:x_ten/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required AuthRemoteDataSource remote, required TokenStorage tokens})
      : _remote = remote,
        _tokens = tokens;

  final AuthRemoteDataSource _remote;
  final TokenStorage _tokens;

  @override
  Future<Result<String>> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) =>
      guard(() => _remote.register(fullName: fullName, email: email, phone: phone, password: password));

  @override
  Future<Result<void>> verifyPhone({required String registrationToken, required String otp}) =>
      guard(() => _remote.verifyPhone(registrationToken: registrationToken, otp: otp));

  @override
  Future<Result<void>> resendOtp(String registrationToken) => guard(() => _remote.resendOtp(registrationToken));

  @override
  Future<Result<AuthSession>> selectRole({required String registrationToken, required Role role}) =>
      guard(() async => _startSession(await _remote.selectRole(registrationToken: registrationToken, role: role)));

  @override
  Future<Result<AuthSession>> login({required String email, required String password}) =>
      guard(() async => _startSession(await _remote.login(email: email, password: password)));

  @override
  Future<Result<void>> requestPasswordReset(String phone) => guard(() => _remote.requestPasswordReset(phone));

  @override
  Future<Result<void>> confirmPasswordReset({
    required String phone,
    required String otp,
    required String newPassword,
  }) =>
      guard(() async {
        await _remote.confirmPasswordReset(phone: phone, otp: otp, newPassword: newPassword);
        await _tokens.clear();
      });

  @override
  Future<Result<User>> getCurrentUser() => guard(() => _remote.getMe());

  @override
  Future<bool> hasSession() => _tokens.hasSession();

  @override
  Future<void> logout() => _tokens.clear();

  Future<AuthSession> _startSession(AuthResponseModel response) async {
    await _tokens.saveTokens(access: response.access, refresh: response.refresh);
    return response;
  }
}
