import 'package:x_ten/core/enums/role.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/auth/domain/entities/auth_session.dart';
import 'package:x_ten/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  Future<Result<String>> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  });

  Future<Result<void>> verifyPhone({required String registrationToken, required String otp});

  Future<Result<void>> resendOtp(String registrationToken);

  Future<Result<AuthSession>> selectRole({required String registrationToken, required Role role});

  Future<Result<AuthSession>> login({required String email, required String password});

  Future<Result<void>> requestPasswordReset(String phone);

  Future<Result<void>> confirmPasswordReset({
    required String phone,
    required String otp,
    required String newPassword,
  });

  Future<Result<User>> getCurrentUser();

  Future<bool> hasSession();

  Future<void> logout();
}
