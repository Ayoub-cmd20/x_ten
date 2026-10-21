import 'package:x_ten/core/constants/api_keys.dart';
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

        // معرض الأعمال اختياري ويتعدّل حتى بعد التوثيق: نجيبوه دايماً
        final portfolio = await _remote.getPortfolio(current.id);

        if (current.isDraft) {
          final socialAccounts = await _remote.getSocialAccounts(current.id);
          final financialAccounts = await _remote.getFinancialAccounts(current.id);
          final documents = await _remote.getDocuments(current.id);
          return RegistrationBundle(
            registration: current,
            socialAccounts: socialAccounts,
            portfolio: portfolio,
            financialAccounts: financialAccounts,
            documents: documents,
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
        return RegistrationBundle(registration: current, portfolio: portfolio, meeting: meeting);
      });

  @override
  Future<Result<Registration>> create(PersonalInfo personal) =>
      guard(() => _remote.createRegistration(RegistrationJson.section(personal)));

  @override
  Future<Result<Registration>> createDraft() => guard(() => _remote.createRegistration(const {}));

  @override
  Future<Result<Registration>> saveSection(int id, RegistrationSection section) =>
      guard(() => _remote.updateRegistration(id, RegistrationJson.section(section)));

  @override
  Future<Result<Registration>> submit(int id) => guard(() => _remote.submit(id));

  @override
  Future<Result<Registration>> uploadProfileImage(int id, UploadFile image) =>
      guard(() => _remote.uploadProfileImage(id, image));

  @override
  Future<Result<void>> deleteProfileImage(int id) => guard(() => _remote.deleteProfileImage(id));

  @override
  Future<Result<SocialAccount>> addSocialAccount(int registrationId, String url) =>
      guard(() => _remote.addSocialAccount(registrationId, {ApiKeys.url: url}));

  @override
  Future<Result<SocialAccount>> updateSocialAccount(int id, {required String accountName, required int followers}) =>
      guard(() => _remote.updateSocialAccount(id, {ApiKeys.accountName: accountName, ApiKeys.followers: followers}));

  @override
  Future<Result<SocialAccount>> refreshSocialAccount(int id) => guard(() => _remote.refreshSocialAccount(id));

  @override
  Future<Result<void>> deleteSocialAccount(int id) => guard(() => _remote.deleteSocialAccount(id));

  @override
  Future<Result<SocialAccount>> applySocialScreenshot(int id, UploadFile image) =>
      guard(() => _remote.uploadSocialScreenshot(id, image));

  @override
  Future<Result<Audience>> scanAudience(
    int registrationId,
    UploadFile image, {
    required String platform,
    required String language,
  }) =>
      guard(() => _remote.scanAudience(
            registrationId,
            {ApiKeys.platform: platform, ApiKeys.language: language},
            image,
          ));

  @override
  Future<Result<PortfolioItem>> addPortfolioItem(int registrationId, PortfolioItem item, UploadFile? file) =>
      guard(() => _remote.addPortfolioItem(registrationId, RegistrationJson.portfolioItem(item), file));

  @override
  Future<Result<void>> deletePortfolioItem(int id) => guard(() => _remote.deletePortfolioItem(id));

  @override
  Future<Result<FinancialAccount>> addFinancialAccount(int registrationId, FinancialAccount account) =>
      guard(() => _remote.addFinancialAccount(registrationId, RegistrationJson.financialAccount(account)));

  @override
  Future<Result<void>> deleteFinancialAccount(int id) => guard(() => _remote.deleteFinancialAccount(id));

  @override
  Future<Result<FinancialScan>> scanCcpCheque(int registrationId, UploadFile file) =>
      guard(() => _remote.scanCcpCheque(registrationId, file));

  @override
  Future<Result<RegistrationDocument>> uploadDocument(
    int registrationId,
    DocumentType type,
    UploadFile file, {
    int? financialAccountId,
    bool acceptUnreadable = false,
  }) =>
      guard(() => _remote.uploadDocument(
            registrationId,
            {
              ApiKeys.type: type.name,
              ApiKeys.financialAccountId: ?financialAccountId,
              if (acceptUnreadable) ApiKeys.acceptUnreadable: true,
            },
            file,
          ));

  @override
  Future<Result<void>> deleteDocument(int id) => guard(() => _remote.deleteDocument(id));
}
