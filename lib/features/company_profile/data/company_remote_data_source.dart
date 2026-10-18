import 'package:dio/dio.dart';
import 'package:x_ten/core/constants/api_endpoints.dart';
import 'package:x_ten/core/constants/api_keys.dart';
import 'package:x_ten/core/network/api_consumer.dart';
import 'package:x_ten/features/company_profile/data/company_models.dart';
import 'package:x_ten/features/company_profile/domain/company_entities.dart';

abstract interface class CompanyRemoteDataSource {
  Future<CompanyProfileModel> getProfile();

  Future<CompanyProfileModel> createProfile(Json body);

  Future<CompanyProfileModel> updateProfile(Json body);

  Future<CompanyProfileModel> submit();

  Future<List<CompanyDocumentModel>> getDocuments();

  Future<CompanyDocumentModel> uploadDocument(CompanyDocumentType type, UploadFile file);

  Future<void> deleteDocument(int id);
}

class CompanyRemoteDataSourceImpl implements CompanyRemoteDataSource {
  const CompanyRemoteDataSourceImpl(this._api);

  final ApiConsumer _api;

  @override
  Future<CompanyProfileModel> getProfile() async =>
      CompanyProfileModel.fromJson(await _api.get(ApiEndpoints.companyProfile) as Json);

  @override
  Future<CompanyProfileModel> createProfile(Json body) async =>
      CompanyProfileModel.fromJson(await _api.post(ApiEndpoints.companyProfile, data: body) as Json);

  @override
  Future<CompanyProfileModel> updateProfile(Json body) async =>
      CompanyProfileModel.fromJson(await _api.patch(ApiEndpoints.companyProfile, data: body) as Json);

  @override
  Future<CompanyProfileModel> submit() async =>
      CompanyProfileModel.fromJson(await _api.post(ApiEndpoints.companySubmit) as Json);

  @override
  Future<List<CompanyDocumentModel>> getDocuments() async {
    final data = await _api.get(ApiEndpoints.companyDocuments);
    final items = switch (data) {
      final List list => list,
      {ApiKeys.results: final List results} => results,
      _ => const <Object?>[],
    };
    return [for (final item in items) CompanyDocumentModel.fromJson(item as Json)];
  }

  @override
  Future<CompanyDocumentModel> uploadDocument(CompanyDocumentType type, UploadFile file) async {
    final form = FormData.fromMap({
      ApiKeys.type: type.name,
      ApiKeys.file: await MultipartFile.fromFile(file.path, filename: file.name),
    });
    return CompanyDocumentModel.fromJson(await _api.post(ApiEndpoints.companyDocuments, data: form) as Json);
  }

  @override
  Future<void> deleteDocument(int id) => _api.delete(ApiEndpoints.companyDocument(id));
}
