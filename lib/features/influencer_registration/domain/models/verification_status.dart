enum InfluencerVerificationStatus {
  draft,
  submitted,
  underReview,
  meetingRequired,
  meetingScheduled,
  verified,
  needsChanges,
  rejected,
}

extension InfluencerVerificationStatusExtension
on InfluencerVerificationStatus {
  String get arabicName {
    switch (this) {
      case InfluencerVerificationStatus.draft:
        return 'مسودة';

      case InfluencerVerificationStatus
          .submitted:
        return 'تم إرسال الطلب';

      case InfluencerVerificationStatus
          .underReview:
        return 'قيد المراجعة';

      case InfluencerVerificationStatus
          .meetingRequired:
        return 'مطلوب اجتماع توثيق';

      case InfluencerVerificationStatus
          .meetingScheduled:
        return 'تم تحديد موعد الاجتماع';

      case InfluencerVerificationStatus
          .verified:
        return 'موثق';

      case InfluencerVerificationStatus
          .needsChanges:
        return 'مطلوب تعديل المعلومات';

      case InfluencerVerificationStatus
          .rejected:
        return 'مرفوض';
    }
  }

  bool get isVerified =>
      this ==
          InfluencerVerificationStatus.verified;
}