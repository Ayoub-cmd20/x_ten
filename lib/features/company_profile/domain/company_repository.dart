import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/company_profile/domain/company_entities.dart';

abstract interface class CompanyRepository {
  Future<Result<CompanyBundle>> load();

  Future<Result<CompanyProfile>> create(BusinessType type);

  Future<Result<CompanyProfile>> updateType(BusinessType type);

  Future<Result<CompanyProfile>> updateInfo(BusinessType type, CompanyInfo info);

  Future<Result<CompanyProfile>> updateContact(CompanyContact contact);

  Future<Result<CompanyProfile>> updateConsents(CompanyConsents consents);

  Future<Result<CompanyProfile>> submit();

  Future<Result<CompanyDocument>> uploadDocument(CompanyDocumentType type, UploadFile file);

  Future<Result<void>> deleteDocument(int id);
}
