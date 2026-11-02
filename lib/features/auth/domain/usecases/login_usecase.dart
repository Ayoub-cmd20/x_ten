import 'package:x_ten/core/usecase/usecase.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/auth/domain/entities/auth_session.dart';
import 'package:x_ten/features/auth/domain/repositories/auth_repository.dart';

typedef LoginParams = ({String email, String password});

class LoginUseCase implements UseCase<AuthSession, LoginParams> {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<AuthSession>> call(LoginParams params) =>
      _repository.login(email: params.email.trim(), password: params.password);
}
