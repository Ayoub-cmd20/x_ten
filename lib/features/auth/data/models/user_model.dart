import 'package:x_ten/core/constants/api_keys.dart';
import 'package:x_ten/core/enums/account_status.dart';
import 'package:x_ten/core/enums/role.dart';
import 'package:x_ten/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phone,
    required super.role,
    required super.roleState,
    required super.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json[ApiKeys.id] as int,
        fullName: json[ApiKeys.fullName] as String? ?? '',
        email: json[ApiKeys.email] as String? ?? '',
        phone: json[ApiKeys.phone] as String? ?? '',
        role: Role.fromApi(json[ApiKeys.role] as String?),
        roleState: RoleState.fromApi(json[ApiKeys.roleState] as String?),
        status: AccountStatus.fromApi(json[ApiKeys.status] as String?),
      );
}
