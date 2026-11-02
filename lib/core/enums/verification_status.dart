enum VerificationStatus {
  draft,
  submitted,
  underReview,
  meetingRequired,
  meetingScheduled,
  verified,
  needsChanges,
  rejected,
  unknown;

  static VerificationStatus fromApi(String? value) =>
      values.firstWhere((e) => e.name == value, orElse: () => unknown);

  bool get isWaiting =>
      this == submitted || this == underReview || this == meetingRequired || this == meetingScheduled;

  bool get isTerminal => this == verified || this == rejected;
}
