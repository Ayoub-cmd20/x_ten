import 'package:x_ten/core/enums/role.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/usecase/usecase.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/auth/domain/entities/auth_session.dart';
import 'package:x_ten/features/auth/domain/repositories/auth_repository.dart';

typedef SelectRoleParams = ({String registrationToken, Role role});

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
