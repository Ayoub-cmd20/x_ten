import 'package:x_ten/features/auth/domain/repositories/auth_repository.dart';

class CheckSessionUseCase {
  const CheckSessionUseCase(this._repository);

  final AuthRepository _repository;

  Future<bool> call() => _repository.hasSession();
}
