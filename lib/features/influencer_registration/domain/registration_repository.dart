import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';

abstract interface class RegistrationRepository {
  Future<Result<RegistrationBundle>> loadCurrent();

  /// المعلومات الشخصية تنشئ الملف، والأقسام الأخرى تتحفظ عليه.
  Future<Result<Registration>> create(PersonalInfo personal);

  Future<Result<Registration>> saveSection(int id, RegistrationSection section);

  Future<Result<Registration>> submit(int id);

  Future<Result<Registration>> uploadProfileImage(int id, UploadFile image);

  Future<Result<void>> deleteProfileImage(int id);

  /// يحط الرابط ويدرك تقديم: المنصة والاسم والصورة والمتابعين يتعمّرو وحدهم.
  Future<Result<SocialAccount>> addSocialAccount(int registrationId, String url);

  Future<Result<SocialAccount>> updateSocialAccount(int id, {required String accountName, required int followers});

  Future<Result<SocialAccount>> refreshSocialAccount(int id);

  Future<Result<void>> deleteSocialAccount(int id);

  Future<Result<PortfolioItem>> addPortfolioItem(int registrationId, PortfolioItem item, UploadFile? file);

  Future<Result<void>> deletePortfolioItem(int id);

  Future<Result<FinancialAccount>> addFinancialAccount(int registrationId, FinancialAccount account);

  Future<Result<void>> deleteFinancialAccount(int id);

  Future<Result<RegistrationDocument>> uploadDocument(
    int registrationId,
    DocumentType type,
    UploadFile file, {
    int? financialAccountId,
    DocumentCheck check = DocumentCheck.notChecked,
  });

  Future<Result<void>> deleteDocument(int id);
}
