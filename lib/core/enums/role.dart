enum Role {
  contentCreator,
  brand,
  management,
  unknown;

  static Role fromApi(String? value) =>
      values.firstWhere((e) => e.name == value, orElse: () => unknown);
}

enum RoleState {
  active,
  pendingApproval,
  suspended,
  revoked,
  unknown;

  static RoleState fromApi(String? value) =>
      values.firstWhere((e) => e.name == value, orElse: () => unknown);
}
