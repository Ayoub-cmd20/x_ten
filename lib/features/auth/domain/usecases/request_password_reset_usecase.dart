import 'package:x_ten/core/usecase/usecase.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/auth/domain/repositories/auth_repository.dart';
import 'package:x_ten/features/auth/domain/usecases/normalize_phone.dart';

class RequestPasswordResetUseCase implements UseCase<void, String> {
  const RequestPasswordResetUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(String phone) => _repository.requestPasswordReset(normalizePhone(phone));
}
