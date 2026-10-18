import 'package:x_ten/core/errors/exceptions.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/company_profile/data/company_models.dart';
import 'package:x_ten/features/company_profile/data/company_remote_data_source.dart';
import 'package:x_ten/features/company_profile/domain/company_entities.dart';
import 'package:x_ten/features/company_profile/domain/company_repository.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  const CompanyRepositoryImpl(this._remote);

  final CompanyRemoteDataSource _remote;

  @override
  Future<Result<CompanyBundle>> load() => guard(() async {
        final CompanyProfile profile;
        try {
          profile = await _remote.getProfile();
        } on ServerException catch (e) {
          if (e.statusCode == 404) return const CompanyBundle();
          rethrow;
        }
        if (!profile.isEditable) return CompanyBundle(profile: profile);
        return CompanyBundle(profile: profile, documents: await _remote.getDocuments());
      });

  @override
  Future<Result<CompanyProfile>> create(BusinessType type) => guard(() => _remote.createProfile(CompanyJson.type(type)));

  @override
  Future<Result<CompanyProfile>> updateType(BusinessType type) =>
      guard(() => _remote.updateProfile(CompanyJson.type(type)));

  @override
  Future<Result<CompanyProfile>> updateInfo(BusinessType type, CompanyInfo info) =>
      guard(() => _remote.updateProfile(CompanyJson.info(type, info)));

  @override
  Future<Result<CompanyProfile>> updateContact(CompanyContact contact) =>
      guard(() => _remote.updateProfile(CompanyJson.contact(contact)));

  @override
  Future<Result<CompanyProfile>> updateConsents(CompanyConsents consents) =>
      guard(() => _remote.updateProfile(CompanyJson.consents(consents)));

  @override
  Future<Result<CompanyProfile>> submit() => guard(_remote.submit);

  @override
  Future<Result<CompanyDocument>> uploadDocument(CompanyDocumentType type, UploadFile file) =>
      guard(() => _remote.uploadDocument(type, file));

  @override
  Future<Result<void>> deleteDocument(int id) => guard(() => _remote.deleteDocument(id));
}
