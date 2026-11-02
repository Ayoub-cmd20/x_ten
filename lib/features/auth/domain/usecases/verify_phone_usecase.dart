import 'package:x_ten/core/usecase/usecase.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/auth/domain/repositories/auth_repository.dart';

typedef VerifyPhoneParams = ({String registrationToken, String otp});

class VerifyPhoneUseCase implements UseCase<void, VerifyPhoneParams> {
  const VerifyPhoneUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(VerifyPhoneParams params) => _repository.verifyPhone(
        registrationToken: params.registrationToken,
        otp: params.otp.trim(),
      );
}
