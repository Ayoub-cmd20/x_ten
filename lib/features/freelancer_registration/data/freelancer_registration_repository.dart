import '../domain/models/freelancer_registration.dart';
import '../domain/models/freelancer_verification_status.dart';

abstract class FreelancerRegistrationRepository {
  Future<void> saveDraft(FreelancerRegistration registration);

  Future<String> submitRegistration(FreelancerRegistration registration);

  Future<FreelancerVerificationStatus> getVerificationStatus(
    String registrationId,
  );
}
