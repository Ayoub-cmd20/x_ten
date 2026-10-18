import 'package:x_ten/core/enums/verification_status.dart';
import 'package:x_ten/features/company_profile/domain/company_entities.dart';

abstract final class CompanyRoutes {
  static const gate = '/company-registration';
  static const form = '/company-registration/form';
  static const status = '/company-registration/status';
  static const advertiserHome = '/advertiser/home';

  static String destinationFor(CompanyProfile? profile) => switch (profile?.status) {
        null || VerificationStatus.draft || VerificationStatus.needsChanges => form,
        VerificationStatus.rejected => status,
        _ => advertiserHome,
      };
}
