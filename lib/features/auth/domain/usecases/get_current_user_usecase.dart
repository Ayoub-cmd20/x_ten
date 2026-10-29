import 'package:x_ten/core/usecase/usecase.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/auth/domain/entities/user.dart';
import 'package:x_ten/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase implements UseCase<User, NoParams> {
  const GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<User>> call(NoParams params) => _repository.getCurrentUser();
}
