import 'package:x_ten/core/constants/api_keys.dart';
import 'package:x_ten/core/enums/verification_status.dart';
import 'package:x_ten/features/company_profile/domain/company_entities.dart';

typedef Json = Map<String, dynamic>;

String _string(Object? value) => value as String? ?? '';

DateTime? _date(Object? value) => value is String ? DateTime.tryParse(value) : null;

String _formatDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

T? _enum<T extends Enum>(List<T> values, Object? value) => values.where((e) => e.name == value).firstOrNull;

abstract final class CompanyJson {
  static Json type(BusinessType type) => {ApiKeys.businessType: type.name};

  static Json info(BusinessType type, CompanyInfo info) => {
        ApiKeys.businessType: type.name,
        ApiKeys.ownerName: info.ownerName,
        ApiKeys.address: info.address,
        ApiKeys.companyName: info.companyName,
        ApiKeys.branch: info.branch,
        ApiKeys.registrationNumber: info.registrationNumber,
        ApiKeys.establishmentDate: switch (info.establishmentDate) {
          final date? => _formatDate(date),
          null => null,
        },
        ApiKeys.ns: info.ns,
        ApiKeys.nif: info.nif,
        ApiKeys.rib: info.rib,
        ApiKeys.professionalTitle: info.professionalTitle,
        ApiKeys.activity: info.activity,
        ApiKeys.nationalIdNumber: info.nationalIdNumber,
        ApiKeys.declaredIndividualActivity: info.declaredIndividualActivity,
      };

  static Json contact(CompanyContact contact) => {
        ApiKeys.phone: contact.phone,
        ApiKeys.email: contact.email,
        ApiKeys.website: contact.website,
        ApiKeys.marketingLinks: contact.marketingLinks,
      };

  static Json consents(CompanyConsents consents) => {
        ApiKeys.confirmInformation: consents.confirmInformation,
        ApiKeys.acceptedTerms: consents.acceptedTerms,
        ApiKeys.acceptedPrivacy: consents.acceptedPrivacy,
      };
}

class CompanyProfileModel extends CompanyProfile {
  const CompanyProfileModel({
    required super.id,
    required super.info,
    required super.contact,
    required super.consents,
    required super.status,
    super.businessType,
    super.logoUrl,
    super.submittedAt,
    super.updatedAt,
  });

  factory CompanyProfileModel.fromJson(Json json) => CompanyProfileModel(
        id: json[ApiKeys.id] as int,
        businessType: _enum(BusinessType.values, json[ApiKeys.businessType]),
        info: CompanyInfo(
          ownerName: _string(json[ApiKeys.ownerName]),
          companyName: _string(json[ApiKeys.companyName]),
          branch: _string(json[ApiKeys.branch]),
          address: _string(json[ApiKeys.address]),
          registrationNumber: _string(json[ApiKeys.registrationNumber]),
          establishmentDate: _date(json[ApiKeys.establishmentDate]),
          ns: _string(json[ApiKeys.ns]),
          nif: _string(json[ApiKeys.nif]),
          rib: _string(json[ApiKeys.rib]),
          professionalTitle: _string(json[ApiKeys.professionalTitle]),
          activity: _string(json[ApiKeys.activity]),
          nationalIdNumber: _string(json[ApiKeys.nationalIdNumber]),
          declaredIndividualActivity: json[ApiKeys.declaredIndividualActivity] as bool? ?? false,
        ),
        contact: CompanyContact(
          phone: _string(json[ApiKeys.phone]),
          email: _string(json[ApiKeys.email]),
          website: _string(json[ApiKeys.website]),
          marketingLinks: [for (final link in json[ApiKeys.marketingLinks] as List? ?? const []) '$link'],
        ),
        consents: CompanyConsents(
          confirmInformation: json[ApiKeys.confirmInformation] as bool? ?? false,
          acceptedTerms: json[ApiKeys.acceptedTerms] as bool? ?? false,
          acceptedPrivacy: json[ApiKeys.acceptedPrivacy] as bool? ?? false,
        ),
        logoUrl: switch (json[ApiKeys.logo]) {
          final String url when url.isNotEmpty => url,
          _ => null,
        },
        status: VerificationStatus.fromApi(json[ApiKeys.verificationStatus] as String?),
        submittedAt: _date(json[ApiKeys.submittedAt]),
        updatedAt: _date(json[ApiKeys.updatedAt]),
      );
}

class CompanyDocumentModel extends CompanyDocument {
  const CompanyDocumentModel({
    required super.id,
    required super.type,
    required super.fileName,
    required super.verified,
    required super.downloadUrl,
  });

  factory CompanyDocumentModel.fromJson(Json json) => CompanyDocumentModel(
        id: json[ApiKeys.id] as int,
        type: _enum(CompanyDocumentType.values, json[ApiKeys.type]) ?? CompanyDocumentType.other,
        fileName: _string(json[ApiKeys.fileName]),
        verified: json[ApiKeys.verified] as bool? ?? false,
        downloadUrl: _string(json[ApiKeys.downloadUrl]),
      );
}
