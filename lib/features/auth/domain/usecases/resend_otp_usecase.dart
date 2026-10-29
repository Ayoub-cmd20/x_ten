import 'package:x_ten/core/usecase/usecase.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/auth/domain/repositories/auth_repository.dart';

class ResendOtpUseCase implements UseCase<void, String> {
  const ResendOtpUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(String registrationToken) => _repository.resendOtp(registrationToken);
}
