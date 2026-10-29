import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/company_profile/domain/company_entities.dart';

typedef CompanyUpload = ({
  CompanyDocumentType type,
  UploadFile file,
  int? financialAccountId,
  String description,
  bool acceptUnreadable,
});

abstract interface class CompanyRepository {
  Future<Result<CompanyBundle>> load();

  Future<Result<CompanyProfile>> create(BusinessType type);

  Future<Result<CompanyProfile>> updateType(BusinessType type);

  Future<Result<CompanyProfile>> saveSection(CompanySection section);

  Future<Result<CompanyProfile>> uploadPhoto(UploadFile image);

  Future<Result<void>> deletePhoto();

  Future<Result<CompanyDocument>> uploadDocument(CompanyUpload upload);

  Future<Result<void>> deleteDocument(int id);

  Future<Result<FinancialAccount>> addFinancialAccount(FinancialAccount account);

  Future<Result<void>> deleteFinancialAccount(int id);

  Future<Result<FinancialAccount>> readFinancialDocument(UploadFile file);

  Future<Result<MarketingPage>> readMarketingScreenshot(UploadFile file, String url);

  Future<Result<CompanyProfile>> submit();
}
