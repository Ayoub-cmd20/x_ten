import '../domain/models/freelancer_registration.dart';
import '../domain/models/freelancer_verification_status.dart';
import 'freelancer_registration_repository.dart';

class FreelancerRegistrationDemoRepository
    implements FreelancerRegistrationRepository {
  FreelancerRegistration? _draft;
  FreelancerRegistration? _submitted;
  FreelancerVerificationStatus _status = FreelancerVerificationStatus.draft;
  int _counter = 1;

  FreelancerRegistration? get draft => _draft;

  @override
  Future<void> saveDraft(FreelancerRegistration registration) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _draft = registration;
  }

  @override
  Future<String> submitRegistration(
    FreelancerRegistration registration,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    final id = 'FRL-REG-${_counter.toString().padLeft(5, '0')}';
    _counter++;
    _status = FreelancerVerificationStatus.submitted;
    _submitted = registration.copyWith(
      id: id,
      registeredAt: DateTime.now(),
      verificationStatus: _status,
    );
    _draft = null;
    return id;
  }

  @override
  Future<FreelancerVerificationStatus> getVerificationStatus(String id) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _submitted?.id == id ? _status : FreelancerVerificationStatus.draft;
  }
}
