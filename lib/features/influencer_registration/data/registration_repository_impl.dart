import 'package:x_ten/core/enums/verification_status.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/influencer_registration/data/registration_models.dart';
import 'package:x_ten/features/influencer_registration/data/registration_remote_data_source.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_repository.dart';

class RegistrationRepositoryImpl implements RegistrationRepository {
  const RegistrationRepositoryImpl(this._remote);

  final RegistrationRemoteDataSource _remote;

  @override
  Future<Result<RegistrationBundle>> loadCurrent() => guard(() async {
        final registrations = await _remote.getRegistrations();
        final current = registrations.where((r) => r.isCurrent).firstOrNull;
        if (current == null) return const RegistrationBundle();

        if (current.isDraft) {
          final results = await Future.wait<List<Object>>([
            _remote.getSocialAccounts(current.id),
            _remote.getPortfolio(current.id),
            _remote.getDocuments(current.id),
          ], eagerError: true);
          return RegistrationBundle(
            registration: current,
            socialAccounts: results[0].cast<SocialAccount>(),
            portfolio: results[1].cast<PortfolioItem>(),
            documents: results[2].cast<RegistrationDocument>(),
          );
        }

        VerificationMeeting? meeting;
        if (current.status == VerificationStatus.meetingScheduled) {
          final meetings = await _remote.getMeetings();
          meeting = meetings
              .where((m) => m.contextId == current.id && m.status == MeetingStatus.scheduled)
              .fold<VerificationMeeting?>(
                null,
                (latest, m) => latest == null || m.scheduledAt.isAfter(latest.scheduledAt) ? m : latest,
              );
        }
        return RegistrationBundle(registration: current, meeting: meeting);
      });

  @override
  Future<Result<Registration>> create({required BasicInfo basic, required ProfileInfo profile}) => guard(
        () => _remote.createRegistration({...RegistrationJson.basic(basic), ...RegistrationJson.profile(profile)}),
      );

  @override
  Future<Result<Registration>> updateBasic(int id, BasicInfo basic) =>
      guard(() => _remote.updateRegistration(id, RegistrationJson.basic(basic)));

  @override
  Future<Result<Registration>> updateProfile(int id, ProfileInfo profile) =>
      guard(() => _remote.updateRegistration(id, RegistrationJson.profile(profile)));

  @override
  Future<Result<Registration>> updateFinancial(int id, FinancialInfo financial) =>
      guard(() => _remote.updateRegistration(id, RegistrationJson.financial(financial)));

  @override
  Future<Result<Registration>> updateConsents(
    int id, {
    required Consents consents,
    required NotificationPreferences notifications,
  }) =>
      guard(() => _remote.updateRegistration(id, RegistrationJson.consents(consents, notifications)));

  @override
  Future<Result<Registration>> submit(int id) => guard(() => _remote.submit(id));

  @override
  Future<Result<Registration>> uploadProfileImage(int id, UploadFile image) =>
      guard(() => _remote.uploadProfileImage(id, image));

  @override
  Future<Result<void>> deleteProfileImage(int id) => guard(() => _remote.deleteProfileImage(id));

  @override
  Future<Result<SocialAccount>> addSocialAccount(int registrationId, SocialAccount account) =>
      guard(() => _remote.addSocialAccount(registrationId, RegistrationJson.socialAccount(account)));

  @override
  Future<Result<void>> deleteSocialAccount(int id) => guard(() => _remote.deleteSocialAccount(id));

  @override
  Future<Result<PortfolioItem>> addPortfolioItem(int registrationId, PortfolioItem item) =>
      guard(() => _remote.addPortfolioItem(registrationId, RegistrationJson.portfolioItem(item)));

  @override
  Future<Result<void>> deletePortfolioItem(int id) => guard(() => _remote.deletePortfolioItem(id));

  @override
  Future<Result<RegistrationDocument>> uploadDocument(int registrationId, DocumentType type, UploadFile file) =>
      guard(() => _remote.uploadDocument(registrationId, type, file));

  @override
  Future<Result<void>> deleteDocument(int id) => guard(() => _remote.deleteDocument(id));
}
