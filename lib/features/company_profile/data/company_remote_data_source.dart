import 'package:dio/dio.dart';
import 'package:x_ten/core/constants/api_endpoints.dart';
import 'package:x_ten/core/constants/api_keys.dart';
import 'package:x_ten/core/network/api_consumer.dart';
import 'package:x_ten/features/company_profile/data/company_models.dart';
import 'package:x_ten/features/company_profile/domain/company_entities.dart';
import 'package:x_ten/features/company_profile/domain/company_repository.dart';

abstract interface class CompanyRemoteDataSource {
  Future<CompanyProfileModel> getProfile();

  Future<CompanyProfileModel> createProfile(Json body);

  Future<CompanyProfileModel> updateProfile(Json body);

  Future<CompanyProfileModel> uploadPhoto(UploadFile image);

  Future<void> deletePhoto();

  Future<CompanyProfileModel> submit();

  Future<List<CompanyDocumentModel>> getDocuments();

  Future<CompanyDocumentModel> uploadDocument(CompanyUpload upload);

  Future<void> deleteDocument(int id);

  Future<List<FinancialAccountModel>> getFinancialAccounts();

  Future<FinancialAccountModel> addFinancialAccount(Json body);

  Future<void> deleteFinancialAccount(int id);

  Future<FinancialAccount> readFinancialDocument(UploadFile file);

  Future<MarketingPage> readMarketingScreenshot(UploadFile file, String url);
}

class CompanyRemoteDataSourceImpl implements CompanyRemoteDataSource {
  const CompanyRemoteDataSourceImpl(this._api);

  final ApiConsumer _api;

  static List<T> _list<T>(Object? data, T Function(Json json) parse) {
    final items = switch (data) {
      final List list => list,
      {ApiKeys.results: final List results} => results,
      _ => const <Object?>[],
    };
    return [for (final item in items) parse(item as Json)];
  }

  static Future<MultipartFile> _multipart(UploadFile file) => MultipartFile.fromFile(file.path, filename: file.name);

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
  Future<CompanyProfileModel> uploadPhoto(UploadFile image) async {
    final form = FormData.fromMap({ApiKeys.image: await _multipart(image)});
    return CompanyProfileModel.fromJson(await _api.put(ApiEndpoints.companyImage, data: form) as Json);
  }

  @override
  Future<void> deletePhoto() => _api.delete(ApiEndpoints.companyImage);

  @override
  Future<CompanyProfileModel> submit() async =>
      CompanyProfileModel.fromJson(await _api.post(ApiEndpoints.companySubmit) as Json);

  @override
  Future<List<CompanyDocumentModel>> getDocuments() async =>
      _list(await _api.get(ApiEndpoints.companyDocuments), CompanyDocumentModel.fromJson);

  @override
  Future<CompanyDocumentModel> uploadDocument(CompanyUpload upload) async {
    final form = FormData.fromMap({
      ApiKeys.type: upload.type.name,
      ApiKeys.file: await _multipart(upload.file),
      ApiKeys.financialAccountId: ?upload.financialAccountId,
      if (upload.description.isNotEmpty) ApiKeys.description: upload.description,
      if (upload.acceptUnreadable) ApiKeys.acceptUnreadable: true,
    });
    return CompanyDocumentModel.fromJson(await _api.post(ApiEndpoints.companyDocuments, data: form) as Json);
  }

  @override
  Future<void> deleteDocument(int id) => _api.delete(ApiEndpoints.companyDocument(id));

  @override
  Future<List<FinancialAccountModel>> getFinancialAccounts() async =>
      _list(await _api.get(ApiEndpoints.companyFinancialAccounts), FinancialAccountModel.fromJson);

  @override
  Future<FinancialAccountModel> addFinancialAccount(Json body) async =>
      FinancialAccountModel.fromJson(await _api.post(ApiEndpoints.companyFinancialAccounts, data: body) as Json);

  @override
  Future<void> deleteFinancialAccount(int id) => _api.delete(ApiEndpoints.companyFinancialAccount(id));

  @override
  Future<FinancialAccount> readFinancialDocument(UploadFile file) async {
    final form = FormData.fromMap({ApiKeys.file: await _multipart(file)});
    return RegistrationJson.readInstitutionAccount(await _api.post(ApiEndpoints.companyFinancialRead, data: form) as Json);
  }

  @override
  Future<MarketingPage> readMarketingScreenshot(UploadFile file, String url) async {
    final form = FormData.fromMap({ApiKeys.file: await _multipart(file), ApiKeys.url: url});
    final json = await _api.post(ApiEndpoints.companyMarketingRead, data: form) as Json;
    return MarketingPage(
      url: url,
      accountName: '${json[ApiKeys.accountName] ?? ''}',
      followers: (json[ApiKeys.followers] as num?)?.toInt(),
    );
  }
}
