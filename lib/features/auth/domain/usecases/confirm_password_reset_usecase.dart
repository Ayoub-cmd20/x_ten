import 'package:x_ten/core/usecase/usecase.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/auth/domain/repositories/auth_repository.dart';
import 'package:x_ten/features/auth/domain/usecases/normalize_phone.dart';

typedef ConfirmPasswordResetParams = ({String phone, String otp, String newPassword});

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
