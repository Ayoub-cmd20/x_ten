import 'package:equatable/equatable.dart';
import 'package:x_ten/core/enums/verification_status.dart';

export 'package:x_ten/core/utils/upload_file.dart';

enum BusinessType { registeredBusiness, individualActivity }

enum CompanyDocumentType { identityDocument, commercialRegister, companyStamp, cancelledCheque, other }

abstract final class CompanyCatalog {
  static List<CompanyDocumentType> requiredDocuments(BusinessType? type) => switch (type) {
        BusinessType.registeredBusiness => const [
            CompanyDocumentType.identityDocument,
            CompanyDocumentType.commercialRegister,
            CompanyDocumentType.companyStamp,
            CompanyDocumentType.cancelledCheque,
          ],
        _ => const [],
      };
}

class CompanyInfo extends Equatable {
  const CompanyInfo({
    this.ownerName = '',
    this.companyName = '',
    this.branch = '',
    this.address = '',
    this.registrationNumber = '',
    this.establishmentDate,
    this.ns = '',
    this.nif = '',
    this.rib = '',
    this.professionalTitle = '',
    this.activity = '',
    this.nationalIdNumber = '',
    this.declaredIndividualActivity = false,
  });

  final String ownerName;
  final String companyName;
  final String branch;
  final String address;
  final String registrationNumber;
  final DateTime? establishmentDate;
  final String ns;
  final String nif;
  final String rib;
  final String professionalTitle;
  final String activity;
  final String nationalIdNumber;
  final bool declaredIndividualActivity;

  @override
  List<Object?> get props => [
        ownerName,
        companyName,
        branch,
        address,
        registrationNumber,
        establishmentDate,
        ns,
        nif,
        rib,
        professionalTitle,
        activity,
        nationalIdNumber,
        declaredIndividualActivity,
      ];
}

class CompanyContact extends Equatable {
  const CompanyContact({
    this.phone = '',
    this.email = '',
    this.website = '',
    this.marketingLinks = const [],
  });

  final String phone;
  final String email;
  final String website;
  final List<String> marketingLinks;

  @override
  List<Object?> get props => [phone, email, website, marketingLinks];
}

class CompanyConsents extends Equatable {
  const CompanyConsents({
    this.confirmInformation = false,
    this.acceptedTerms = false,
    this.acceptedPrivacy = false,
  });

  static const allAccepted = CompanyConsents(confirmInformation: true, acceptedTerms: true, acceptedPrivacy: true);

  final bool confirmInformation;
  final bool acceptedTerms;
  final bool acceptedPrivacy;

  bool get all => confirmInformation && acceptedTerms && acceptedPrivacy;

  CompanyConsents copyWith({bool? confirmInformation, bool? acceptedTerms, bool? acceptedPrivacy}) => CompanyConsents(
        confirmInformation: confirmInformation ?? this.confirmInformation,
        acceptedTerms: acceptedTerms ?? this.acceptedTerms,
        acceptedPrivacy: acceptedPrivacy ?? this.acceptedPrivacy,
      );

  @override
  List<Object?> get props => [confirmInformation, acceptedTerms, acceptedPrivacy];
}

class CompanyProfile extends Equatable {
  const CompanyProfile({
    required this.id,
    required this.info,
    required this.contact,
    required this.consents,
    required this.status,
    this.businessType,
    this.logoUrl,
    this.submittedAt,
    this.updatedAt,
  });

  final int id;
  final BusinessType? businessType;
  final CompanyInfo info;
  final CompanyContact contact;
  final CompanyConsents consents;
  final String? logoUrl;
  final VerificationStatus status;
  final DateTime? submittedAt;
  final DateTime? updatedAt;

  bool get isEditable => status == VerificationStatus.draft || status == VerificationStatus.needsChanges;

  bool get isVerified => status == VerificationStatus.verified;

  @override
  List<Object?> get props => [id, businessType, info, contact, consents, logoUrl, status, submittedAt, updatedAt];
}

class CompanyDocument extends Equatable {
  const CompanyDocument({
    required this.id,
    required this.type,
    required this.fileName,
    required this.verified,
    required this.downloadUrl,
  });

  final int id;
  final CompanyDocumentType type;
  final String fileName;
  final bool verified;
  final String downloadUrl;

  @override
  List<Object?> get props => [id, type, fileName, verified, downloadUrl];
}

class CompanyBundle extends Equatable {
  const CompanyBundle({this.profile, this.documents = const []});

  final CompanyProfile? profile;
  final List<CompanyDocument> documents;

  @override
  List<Object?> get props => [profile, documents];
}
