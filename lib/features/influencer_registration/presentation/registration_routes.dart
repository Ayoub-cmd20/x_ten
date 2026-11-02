import 'package:x_ten/core/enums/verification_status.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';

abstract final class RegistrationRoutes {
  static const gate = '/influencer-registration';
  static const form = '/influencer-registration/form';
  static const status = '/influencer-registration/status';

  /// الجمهور والمهارات وأنواع المحتوى ومعرض الأعمال: تتكمّل حتى بعد التوثيق
  static const optional = '/influencer-registration/optional';
  static const creatorHome = '/creator/home';

  static String destinationFor(Registration? registration) => switch (registration?.status) {
        null || VerificationStatus.draft => form,
        VerificationStatus.needsChanges || VerificationStatus.rejected => status,
        _ => creatorHome,
      };
}
