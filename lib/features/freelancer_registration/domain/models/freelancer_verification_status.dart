enum FreelancerVerificationStatus { draft, submitted, underReview, meetingRequired, meetingScheduled, verified, needsChanges, rejected }
extension FreelancerVerificationStatusX on FreelancerVerificationStatus {
  String get arabicName {
    switch (this) {
      case FreelancerVerificationStatus.draft: return 'مسودة';
      case FreelancerVerificationStatus.submitted: return 'تم إرسال الطلب';
      case FreelancerVerificationStatus.underReview: return 'قيد المراجعة';
      case FreelancerVerificationStatus.meetingRequired: return 'مطلوب توثيق الهوية';
      case FreelancerVerificationStatus.meetingScheduled: return 'تم تحديد موعد التوثيق';
      case FreelancerVerificationStatus.verified: return 'تم توثيق الحساب';
      case FreelancerVerificationStatus.needsChanges: return 'مطلوب تعديل المعلومات';
      case FreelancerVerificationStatus.rejected: return 'مرفوض';
    }
  }
}
