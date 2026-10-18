enum AccountStatus {
  pending,
  active,
  suspended,
  rejected,
  unknown;

  static AccountStatus fromApi(String? value) =>
      values.firstWhere((e) => e.name == value, orElse: () => unknown);

  bool get isVerified => this == active;
}
