import 'package:x_ten/core/enums/role.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/usecase/usecase.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/auth/domain/auth_entities.dart';
import 'package:x_ten/features/auth/domain/auth_repository.dart';

typedef RegisterParams = ({String fullName, String email, String phone, String password});
typedef VerifyPhoneParams = ({String registrationToken, String otp});
typedef SelectRoleParams = ({String registrationToken, Role role});
typedef LoginParams = ({String email, String password});
typedef ConfirmPasswordResetParams = ({String phone, String otp, String newPassword});

final _phoneSeparators = RegExp(r'[\s\-().]');

String normalizePhone(String phone) => phone.trim().replaceAll(_phoneSeparators, '');

class RegisterUseCase implements UseCase<String, RegisterParams> {
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<String>> call(RegisterParams params) => _repository.register(
        fullName: params.fullName.trim(),
        email: params.email.trim(),
        phone: normalizePhone(params.phone),
        password: params.password,
      );
}

class VerifyPhoneUseCase implements UseCase<void, VerifyPhoneParams> {
  const VerifyPhoneUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(VerifyPhoneParams params) => _repository.verifyPhone(
        registrationToken: params.registrationToken,
        otp: params.otp.trim(),
      );
}

class ResendOtpUseCase implements UseCase<void, String> {
  const ResendOtpUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(String registrationToken) => _repository.resendOtp(registrationToken);
}

class SelectRoleUseCase implements UseCase<AuthSession, SelectRoleParams> {
  const SelectRoleUseCase(this._repository);

  static const selectableRoles = [Role.contentCreator, Role.brand];

  final AuthRepository _repository;

  @override
  Future<Result<AuthSession>> call(SelectRoleParams params) async {
    if (!selectableRoles.contains(params.role)) {
      return const Err<AuthSession>(
        ValidationFailure(
          message: 'Role is not selectable at registration',
          details: {'role': 'Role is not selectable at registration'},
        ),
      );
    }
    return _repository.selectRole(
      registrationToken: params.registrationToken,
      role: params.role,
    );
  }
}

class LoginUseCase implements UseCase<AuthSession, LoginParams> {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<AuthSession>> call(LoginParams params) =>
      _repository.login(email: params.email.trim(), password: params.password);
}

class RequestPasswordResetUseCase implements UseCase<void, String> {
  const RequestPasswordResetUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(String phone) => _repository.requestPasswordReset(normalizePhone(phone));
}

class ConfirmPasswordResetUseCase implements UseCase<void, ConfirmPasswordResetParams> {
  const ConfirmPasswordResetUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(ConfirmPasswordResetParams params) => _repository.confirmPasswordReset(
        phone: normalizePhone(params.phone),
        otp: params.otp.trim(),
        newPassword: params.newPassword,
      );
}

class GetCurrentUserUseCase implements UseCase<User, NoParams> {
  const GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<User>> call(NoParams params) => _repository.getCurrentUser();
}

class CheckSessionUseCase {
  const CheckSessionUseCase(this._repository);

  final AuthRepository _repository;

  Future<bool> call() => _repository.hasSession();
}

class LogoutUseCase {
  const LogoutUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call() => _repository.logout();
}
