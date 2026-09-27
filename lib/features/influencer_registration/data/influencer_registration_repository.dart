import '../domain/models/influencer_document.dart';
import '../domain/models/influencer_registration.dart';
import '../domain/models/verification_status.dart';

abstract class InfluencerRegistrationRepository {
  /// حفظ التسجيل كمسودة.
  Future<void> saveDraft(
      InfluencerRegistration registration,
      );

  /// تحميل المسودة المحفوظة.
  Future<InfluencerRegistration?>
  getDraft();

  /// إرسال التسجيل النهائي إلى المنصة.
  Future<String> submitRegistration(
      InfluencerRegistration registration,
      );

  /// جلب حالة طلب التوثيق.
  Future<InfluencerVerificationStatus>
  getVerificationStatus(
      String registrationId,
      );

  /// رفع صورة البروفايل.
  ///
  /// ترجع URL أو path الذي سجله الـ backend.
  Future<String> uploadProfileImage(
      String localFilePath,
      );

  /// رفع وثيقة.
  ///
  /// ترجع الوثيقة بعد رفعها.
  Future<InfluencerDocument>
  uploadDocument(
      InfluencerDocument document,
      );

  /// حذف وثيقة مرفوعة.
  Future<void> deleteDocument(
      String documentId,
      );

  /// تحديث بيانات تسجيل موجود.
  Future<void> updateRegistration(
      InfluencerRegistration registration,
      );

  /// سحب / إلغاء طلب التسجيل إذا كان ذلك مسموحاً.
  Future<void> cancelRegistration(
      String registrationId,
      );
}