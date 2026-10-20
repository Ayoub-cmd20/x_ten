import 'package:dio/dio.dart';
import 'package:x_ten/core/constants/api_endpoints.dart';
import 'package:x_ten/core/constants/api_keys.dart';
import 'package:x_ten/core/network/api_consumer.dart';
import 'package:x_ten/features/influencer_registration/data/registration_models.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';

const _meetingContext = 'influencerRegistration';

abstract interface class RegistrationRemoteDataSource {
  Future<List<RegistrationModel>> getRegistrations();

  Future<RegistrationModel> createRegistration(Json body);

  Future<RegistrationModel> updateRegistration(int id, Json body);

  Future<RegistrationModel> submit(int id);

  Future<RegistrationModel> uploadProfileImage(int id, UploadFile image);

  Future<void> deleteProfileImage(int id);

  Future<List<SocialAccountModel>> getSocialAccounts(int registrationId);

  Future<SocialAccountModel> addSocialAccount(int registrationId, Json body);

  Future<SocialAccountModel> updateSocialAccount(int id, Json body);

  Future<SocialAccountModel> refreshSocialAccount(int id);

  Future<void> deleteSocialAccount(int id);

  Future<SocialAccountModel> uploadSocialScreenshot(int id, UploadFile image);

  Future<AudienceModel> scanAudience(int registrationId, Json fields, UploadFile image);

  Future<List<PortfolioItemModel>> getPortfolio(int registrationId);

  Future<PortfolioItemModel> addPortfolioItem(int registrationId, Json body, UploadFile? file);

  Future<void> deletePortfolioItem(int id);

  Future<List<FinancialAccountModel>> getFinancialAccounts(int registrationId);

  Future<FinancialAccountModel> addFinancialAccount(int registrationId, Json body);

  Future<void> deleteFinancialAccount(int id);

  Future<FinancialScanModel> scanFinancialDocument(int registrationId, UploadFile file);

  Future<List<RegistrationDocumentModel>> getDocuments(int registrationId);

  Future<RegistrationDocumentModel> uploadDocument(int registrationId, Json fields, UploadFile file);

  Future<void> deleteDocument(int id);

  Future<List<VerificationMeetingModel>> getMeetings();
}

class RegistrationRemoteDataSourceImpl implements RegistrationRemoteDataSource {
  const RegistrationRemoteDataSourceImpl(this._api);

  final ApiConsumer _api;

  static List<T> _list<T>(Object? data, T Function(Json json) parse) {
    final items = switch (data) {
      final List list => list,
      {ApiKeys.results: final List results} => results,
      _ => const <Object?>[],
    };
    return [for (final item in items) parse(item as Json)];
  }

  static Future<MultipartFile> _multipart(UploadFile file) =>
      MultipartFile.fromFile(file.path, filename: file.name);

  @override
  Future<List<RegistrationModel>> getRegistrations() async =>
      _list(await _api.get(ApiEndpoints.registrations), RegistrationModel.fromJson);

  @override
  Future<RegistrationModel> createRegistration(Json body) async =>
      RegistrationModel.fromJson(await _api.post(ApiEndpoints.registrations, data: body) as Json);

  @override
  Future<RegistrationModel> updateRegistration(int id, Json body) async =>
      RegistrationModel.fromJson(await _api.patch(ApiEndpoints.registration(id), data: body) as Json);

  @override
  Future<RegistrationModel> submit(int id) async =>
      RegistrationModel.fromJson(await _api.post(ApiEndpoints.submitRegistration(id)) as Json);

  @override
  Future<RegistrationModel> uploadProfileImage(int id, UploadFile image) async {
    final form = FormData.fromMap({ApiKeys.image: await _multipart(image)});
    return RegistrationModel.fromJson(await _api.put(ApiEndpoints.profileImage(id), data: form) as Json);
  }

  @override
  Future<void> deleteProfileImage(int id) => _api.delete(ApiEndpoints.profileImage(id));

  @override
  Future<List<SocialAccountModel>> getSocialAccounts(int registrationId) async =>
      _list(await _api.get(ApiEndpoints.socialAccounts(registrationId)), SocialAccountModel.fromJson);

  @override
  Future<SocialAccountModel> addSocialAccount(int registrationId, Json body) async =>
      SocialAccountModel.fromJson(await _api.post(ApiEndpoints.socialAccounts(registrationId), data: body) as Json);

  @override
  Future<SocialAccountModel> updateSocialAccount(int id, Json body) async =>
      SocialAccountModel.fromJson(await _api.patch(ApiEndpoints.socialAccount(id), data: body) as Json);

  @override
  Future<SocialAccountModel> refreshSocialAccount(int id) async =>
      SocialAccountModel.fromJson(await _api.post(ApiEndpoints.refreshSocialAccount(id)) as Json);

  @override
  Future<void> deleteSocialAccount(int id) => _api.delete(ApiEndpoints.socialAccount(id));

  @override
  Future<SocialAccountModel> uploadSocialScreenshot(int id, UploadFile image) async {
    final form = FormData.fromMap({ApiKeys.file: await _multipart(image)});
    return SocialAccountModel.fromJson(await _api.post(ApiEndpoints.socialScreenshot(id), data: form) as Json);
  }

  @override
  Future<AudienceModel> scanAudience(int registrationId, Json fields, UploadFile image) async {
    final form = FormData.fromMap({...fields, ApiKeys.file: await _multipart(image)});
    final data = await _api.post(ApiEndpoints.audienceScreenshots(registrationId), data: form) as Json;
    return AudienceModel.fromJson(data[ApiKeys.audience]);
  }

  @override
  Future<List<PortfolioItemModel>> getPortfolio(int registrationId) async =>
      _list(await _api.get(ApiEndpoints.portfolio(registrationId)), PortfolioItemModel.fromJson);

  @override
  Future<PortfolioItemModel> addPortfolioItem(int registrationId, Json body, UploadFile? file) async {
    final data = file == null ? body : FormData.fromMap({...body, ApiKeys.file: await _multipart(file)});
    return PortfolioItemModel.fromJson(await _api.post(ApiEndpoints.portfolio(registrationId), data: data) as Json);
  }

  @override
  Future<void> deletePortfolioItem(int id) => _api.delete(ApiEndpoints.portfolioItem(id));

  @override
  Future<List<FinancialAccountModel>> getFinancialAccounts(int registrationId) async =>
      _list(await _api.get(ApiEndpoints.financialAccounts(registrationId)), FinancialAccountModel.fromJson);

  @override
  Future<FinancialAccountModel> addFinancialAccount(int registrationId, Json body) async => FinancialAccountModel.fromJson(
        await _api.post(ApiEndpoints.financialAccounts(registrationId), data: body) as Json,
      );

  @override
  Future<void> deleteFinancialAccount(int id) => _api.delete(ApiEndpoints.financialAccount(id));

  @override
  Future<FinancialScanModel> scanFinancialDocument(int registrationId, UploadFile file) async {
    final form = FormData.fromMap({ApiKeys.file: await _multipart(file)});
    return FinancialScanModel.fromJson(await _api.post(ApiEndpoints.financialScan(registrationId), data: form) as Json);
  }

  @override
  Future<List<RegistrationDocumentModel>> getDocuments(int registrationId) async =>
      _list(await _api.get(ApiEndpoints.documents(registrationId)), RegistrationDocumentModel.fromJson);

  @override
  Future<RegistrationDocumentModel> uploadDocument(int registrationId, Json fields, UploadFile file) async {
    final form = FormData.fromMap({...fields, ApiKeys.file: await _multipart(file)});
    return RegistrationDocumentModel.fromJson(await _api.post(ApiEndpoints.documents(registrationId), data: form) as Json);
  }

  @override
  Future<void> deleteDocument(int id) => _api.delete(ApiEndpoints.document(id));

  @override
  Future<List<VerificationMeetingModel>> getMeetings() async => _list(
        await _api.get(ApiEndpoints.meetings, query: {ApiKeys.context: _meetingContext}),
        VerificationMeetingModel.fromJson,
      );
}
