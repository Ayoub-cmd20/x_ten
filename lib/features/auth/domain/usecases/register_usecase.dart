import 'package:x_ten/core/usecase/usecase.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/auth/domain/repositories/auth_repository.dart';
import 'package:x_ten/features/auth/domain/usecases/normalize_phone.dart';

typedef RegisterParams = ({String fullName, String email, String phone, String password});

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
