import 'package:x_ten/core/enums/verification_status.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';

abstract final class RegistrationRoutes {
  static const gate = '/influencer-registration';
  static const form = '/influencer-registration/form';
  static const status = '/influencer-registration/status';
  static const creatorHome = '/creator/home';

  static String destinationFor(Registration? registration) => switch (registration?.status) {
        null || VerificationStatus.draft => form,
        VerificationStatus.verified => creatorHome,
        _ => status,
      };
}
