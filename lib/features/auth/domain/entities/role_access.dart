import 'package:x_ten/core/enums/role.dart';

extension RoleAccess on Role {
  bool get canUseApp => this == Role.contentCreator || this == Role.brand;
}
