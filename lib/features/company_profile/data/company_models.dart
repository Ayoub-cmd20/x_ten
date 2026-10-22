import 'package:x_ten/core/constants/api_keys.dart';
import 'package:x_ten/core/enums/verification_status.dart';
import 'package:x_ten/features/company_profile/domain/company_entities.dart';
import 'package:x_ten/features/influencer_registration/data/registration_models.dart' show ScannedFieldsModel;

export 'package:x_ten/features/influencer_registration/data/registration_models.dart'
    show FinancialAccountModel, RegistrationJson;

typedef Json = Map<String, dynamic>;

String _string(Object? value) => value as String? ?? '';

List<String> _strings(Object? value) => [for (final item in value as List? ?? const []) '$item'];

DateTime? _date(Object? value) => value is String ? DateTime.tryParse(value) : null;

String? _formatDate(DateTime? date) => date == null
    ? null
    : '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

abstract final class CompanyJson {
  static Json type(BusinessType type) => {ApiKeys.businessType: type.name};

  static Json section(CompanySection section) => switch (section) {
        final CompanyPersonal personal => {
            ApiKeys.firstName: personal.firstName,
            ApiKeys.lastName: personal.lastName,
            ApiKeys.idNumber: personal.idNumber,
            ApiKeys.birthDate: _formatDate(personal.birthDate),
            ApiKeys.role: personal.role,
            ApiKeys.roleOther: personal.roleOther,
          },
        final CompanyBusiness business => {
            ApiKeys.accountName: business.accountName,
            ApiKeys.companyName: business.companyName,
            ApiKeys.branch: business.branch,
            ApiKeys.accountNameSource: business.accountNameSource.name,
            ApiKeys.wilaya: business.wilaya,
            ApiKeys.address: business.address,
            ApiKeys.registrationNumber: business.registrationNumber,
            ApiKeys.ns: business.ns,
            ApiKeys.nif: business.nif,
            ApiKeys.capital: business.capital,
          },
        final CompanyPresence presence => {
            ApiKeys.bio: presence.bio,
            ApiKeys.activityAreas: presence.activityAreas,
            ApiKeys.activityOther: presence.activityOther,
            ApiKeys.marketingPages: [
              for (final page in presence.marketingPages) {ApiKeys.url: page.url},
            ],
          },
        final CompanyContact contact => {
            ApiKeys.phone: contact.phone,
            ApiKeys.whatsapp: contact.whatsapp,
            ApiKeys.phone2: contact.phone2,
            ApiKeys.email: contact.email,
          },
        final CompanyConsents consents => {
            ApiKeys.acceptedTerms: consents.acceptedTerms,
            ApiKeys.acceptedPrivacy: consents.acceptedPrivacy,
          },
      };

  static Json financialAccount(FinancialAccount account) => {
        ApiKeys.institutionName: account.institutionName,
        ApiKeys.accountNumber: account.accountNumber,
        if (account.accountKey.isNotEmpty) ApiKeys.accountKey: account.accountKey,
      };
}

class MarketingPageModel extends MarketingPage {
  const MarketingPageModel({required super.url, super.platform, super.username});

  factory MarketingPageModel.fromJson(Json json) => MarketingPageModel(
        url: _string(json[ApiKeys.url]),
        platform: enumFromApi(SocialPlatform.values, json[ApiKeys.platform] as String?, SocialPlatform.website),
        username: _string(json[ApiKeys.username]),
      );
}

class CompanyProfileModel extends CompanyProfile {
  const CompanyProfileModel({
    required super.id,
    required super.status,
    super.businessType,
    super.personal,
    super.business,
    super.presence,
    super.contact,
    super.consents,
    super.displayName,
    super.profileImageUrl,
    super.submittedAt,
    super.updatedAt,
  });

  factory CompanyProfileModel.fromJson(Json json) => CompanyProfileModel(
        id: json[ApiKeys.id] as int,
        businessType: maybeEnum(BusinessType.values, json[ApiKeys.businessType] as String?),
        personal: CompanyPersonal(
          firstName: _string(json[ApiKeys.firstName]),
          lastName: _string(json[ApiKeys.lastName]),
          idNumber: _string(json[ApiKeys.idNumber]),
          birthDate: _date(json[ApiKeys.birthDate]),
          role: _string(json[ApiKeys.role]),
          roleOther: _string(json[ApiKeys.roleOther]),
        ),
        business: CompanyBusiness(
          accountName: _string(json[ApiKeys.accountName]),
          companyName: _string(json[ApiKeys.companyName]),
          branch: _string(json[ApiKeys.branch]),
          accountNameSource: enumFromApi(
            AccountNameSource.values,
            json[ApiKeys.accountNameSource] as String?,
            AccountNameSource.company,
          ),
          wilaya: _string(json[ApiKeys.wilaya]),
          address: _string(json[ApiKeys.address]),
          registrationNumber: _string(json[ApiKeys.registrationNumber]),
          ns: _string(json[ApiKeys.ns]),
          nif: _string(json[ApiKeys.nif]),
          capital: (json[ApiKeys.capital] as num?)?.toInt(),
        ),
        presence: CompanyPresence(
          bio: _string(json[ApiKeys.bio]),
          activityAreas: _strings(json[ApiKeys.activityAreas]),
          activityOther: _string(json[ApiKeys.activityOther]),
          marketingPages: [
            for (final page in json[ApiKeys.marketingPages] as List? ?? const [])
              if (page is Json) MarketingPageModel.fromJson(page),
          ],
        ),
        contact: CompanyContact(
          phone: _string(json[ApiKeys.phone]),
          whatsapp: _string(json[ApiKeys.whatsapp]),
          phone2: _string(json[ApiKeys.phone2]),
          email: _string(json[ApiKeys.email]),
        ),
        consents: CompanyConsents(
          acceptedTerms: json[ApiKeys.acceptedTerms] as bool? ?? false,
          acceptedPrivacy: json[ApiKeys.acceptedPrivacy] as bool? ?? false,
        ),
        displayName: _string(json[ApiKeys.displayName]),
        profileImageUrl: switch (json[ApiKeys.profileImageUrl]) {
          final String url when url.isNotEmpty => url,
          _ => null,
        },
        status: VerificationStatus.fromApi(json[ApiKeys.verificationStatus] as String?),
        submittedAt: _date(json[ApiKeys.submittedAt]),
        updatedAt: _date(json[ApiKeys.updatedAt]),
      );
}

class ScannedBusinessModel extends ScannedBusiness {
  const ScannedBusinessModel({
    super.registrationNumber,
    super.companyName,
    super.address,
    super.wilaya,
    super.capital,
    super.ns,
    super.nif,
    super.title,
  });

  factory ScannedBusinessModel.fromJson(Object? value) {
    if (value is! Json) {
      return const ScannedBusinessModel();
    }
    String text(String key) => value[key] == null ? '' : '${value[key]}';
    return ScannedBusinessModel(
      registrationNumber: text(ApiKeys.registrationNumber),
      companyName: text(ApiKeys.companyName),
      address: text(ApiKeys.address),
      wilaya: text(ApiKeys.wilaya),
      capital: (value[ApiKeys.capital] as num?)?.toInt(),
      ns: text(ApiKeys.nis),
      nif: text(ApiKeys.nif),
      title: text(ApiKeys.title),
    );
  }
}

class CompanyDocumentModel extends CompanyDocument {
  const CompanyDocumentModel({
    required super.id,
    required super.type,
    required super.downloadUrl,
    super.fileName,
    super.description,
    super.financialAccountId,
    super.check,
    super.scanned,
    super.business,
    super.review,
    super.reviewReason,
  });

  factory CompanyDocumentModel.fromJson(Json json) => CompanyDocumentModel(
        id: json[ApiKeys.id] as int,
        type: enumFromApi(CompanyDocumentType.values, json[ApiKeys.type] as String?, CompanyDocumentType.other),
        fileName: _string(json[ApiKeys.fileName]),
        description: _string(json[ApiKeys.description]),
        financialAccountId: json[ApiKeys.financialAccountId] as int?,
        check: enumFromApi(DocumentCheck.values, json[ApiKeys.checkStatus] as String?, DocumentCheck.notChecked),
        scanned: ScannedFieldsModel.fromJson(json[ApiKeys.extracted]),
        business: ScannedBusinessModel.fromJson(json[ApiKeys.extracted]),
        review: enumFromApi(DocumentReview.values, json[ApiKeys.reviewStatus] as String?, DocumentReview.pending),
        reviewReason: _string(json[ApiKeys.reviewReason]),
        downloadUrl: _string(json[ApiKeys.downloadUrl]),
      );
}
