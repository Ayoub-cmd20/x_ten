import 'package:equatable/equatable.dart';
import 'package:x_ten/core/enums/account_status.dart';
import 'package:x_ten/core/enums/role.dart';

class AuthSession extends Equatable {
  const AuthSession({
    required this.role,
    required this.roleState,
    required this.status,
  });

  final Role role;
  final RoleState roleState;
  final AccountStatus status;

  @override
  List<Object?> get props => [role, roleState, status];
}
