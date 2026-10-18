import 'package:equatable/equatable.dart';
import 'package:x_ten/core/enums/account_status.dart';
import 'package:x_ten/core/enums/role.dart';

extension RoleAccess on Role {
  bool get canUseApp => this == Role.contentCreator || this == Role.brand;
}

class User extends Equatable {
  const User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.roleState,
    required this.status,
  });

  final int id;
  final String fullName;
  final String email;
  final String phone;
  final Role role;
  final RoleState roleState;
  final AccountStatus status;

  @override
  List<Object?> get props => [id, fullName, email, phone, role, roleState, status];
}

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
