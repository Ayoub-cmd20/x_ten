import 'package:x_ten/core/constants/api_keys.dart';
import 'package:x_ten/core/enums/account_status.dart';
import 'package:x_ten/core/enums/role.dart';
import 'package:x_ten/features/auth/domain/entities/auth_session.dart';

class AuthResponseModel extends AuthSession {
  const AuthResponseModel({
    required this.access,
    required this.refresh,
    required super.role,
    required super.roleState,
    required super.status,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) => AuthResponseModel(
        access: json[ApiKeys.access] as String,
        refresh: json[ApiKeys.refresh] as String,
        role: Role.fromApi(json[ApiKeys.role] as String?),
        roleState: RoleState.fromApi(json[ApiKeys.roleState] as String?),
        status: AccountStatus.fromApi(json[ApiKeys.accountStatus] as String?),
      );

  final String access;
  final String refresh;
}
