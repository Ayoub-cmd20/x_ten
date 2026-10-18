import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';

abstract interface class RegistrationRepository {
  Future<Result<RegistrationBundle>> loadCurrent();

  Future<Result<Registration>> create({required BasicInfo basic, required ProfileInfo profile});

  Future<Result<Registration>> updateBasic(int id, BasicInfo basic);

  Future<Result<Registration>> updateProfile(int id, ProfileInfo profile);

  Future<Result<Registration>> updateFinancial(int id, FinancialInfo financial);

  Future<Result<Registration>> updateConsents(
    int id, {
    required Consents consents,
    required NotificationPreferences notifications,
  });

  Future<Result<Registration>> submit(int id);

  Future<Result<Registration>> uploadProfileImage(int id, UploadFile image);

  Future<Result<void>> deleteProfileImage(int id);

  Future<Result<SocialAccount>> addSocialAccount(int registrationId, SocialAccount account);

  Future<Result<void>> deleteSocialAccount(int id);

  Future<Result<PortfolioItem>> addPortfolioItem(int registrationId, PortfolioItem item);

  Future<Result<void>> deletePortfolioItem(int id);

  Future<Result<RegistrationDocument>> uploadDocument(int registrationId, DocumentType type, UploadFile file);

  Future<Result<void>> deleteDocument(int id);
}
