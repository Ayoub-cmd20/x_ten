import 'package:equatable/equatable.dart';
import 'package:x_ten/core/enums/verification_status.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart'
    show DocumentCheck, FinancialAccount, ScannedFields, SocialPlatform;

export 'package:x_ten/core/utils/upload_file.dart';
export 'package:x_ten/features/influencer_registration/domain/registration_entities.dart'
    show DocumentCheck, FinancialAccount, FinancialKind, ScannedFields, SocialPlatform, enumFromApi, maybeEnum;

enum BusinessType { registeredBusiness, individualActivity }

enum AccountNameSource { company, branch }

enum CompanyDocumentType {
  identityFront,
  identityBack,
  passport,
  ccpCheque,
  financialProof,
  commercialRegister,
  taxCertificate,
  license,
  other,
}

enum DocumentReview { pending, accepted, rejected }

abstract final class CompanyCatalog {
  static const otherRole = 'other';
  static const otherActivity = 'other';
  static const maxScanAttempts = 3;
  static const maxMarketingPages = 10;
  static const accountNameMin = 3;
  static const accountNameMax = 40;

  static List<String> roles(BusinessType type) => switch (type) {
        BusinessType.individualActivity => const ['owner', 'marketingOfficer', otherRole],
        BusinessType.registeredBusiness => const [
            'companyOwner',
            'marketingDirector',
            'relationsOfficer',
            'storeOwner',
            'projectOwner',
            otherRole,
          ],
      };

  static int maxActivities(BusinessType type) => switch (type) {
        BusinessType.individualActivity => 3,
        BusinessType.registeredBusiness => 5,
      };

  static const sectors = <String, List<String>>{
    'foodBeverage': ['restaurants', 'cafes', 'foodFactories', 'foodDistribution'],
    'trade': ['retail', 'wholesale', 'onlineSales', 'localMarkets'],
    'industry': ['manufacturing', 'factories', 'materialsProduction'],
    'agriculture': ['farming', 'livestock', 'agriProcessing'],
    'realEstate': ['realEstateDevelopment', 'contracting', 'publicWorks'],
    'transport': ['freightTransport', 'warehousing', 'logisticsDistribution', 'delivery'],
    'health': ['clinics', 'laboratories', 'pharmacies', 'medicalManufacturing'],
    'education': ['schools', 'universities', 'trainingCenters', 'privateEducation'],
    'telecomTech': ['telecom', 'techCompanies', 'digitalServices'],
    'tourism': ['hotels', 'travelAgencies', 'resorts', 'leisure'],
    'beauty': ['salons', 'cosmeticClinics', 'careProducts'],
    'fashion': ['clothingStores', 'fashionDesign', 'fashionDistribution'],
    'automotive': ['carSales', 'carMaintenance', 'carRental'],
    'professionalServices': ['law', 'accounting', 'consulting', 'administrativeServices'],
    'media': ['mediaProduction', 'adAgencies', 'events'],
    'homeServices': ['homeMaintenance', 'cleaning', 'smallWorks'],
    'conglomerates': ['holdings', 'investmentGroups', 'financialInstitutions'],
    'government': ['ministries', 'nationalCompanies', 'nonProfits'],
    'individuals': ['freelancer', 'soloActivity', 'smallProjects'],
    'other': [otherActivity],
  };

  static String? sectorOf(String activity) =>
      sectors.entries.where((entry) => entry.value.contains(activity)).firstOrNull?.key;

  static const businessDocuments = [CompanyDocumentType.commercialRegister, CompanyDocumentType.taxCertificate];

  static const identityDocuments = {
    CompanyDocumentType.identityFront,
    CompanyDocumentType.identityBack,
    CompanyDocumentType.passport,
  };
}

sealed class CompanySection extends Equatable {
  const CompanySection();
}

final class CompanyPersonal extends CompanySection {
  const CompanyPersonal({
    this.firstName = '',
    this.lastName = '',
    this.idNumber = '',
    this.birthDate,
    this.role = '',
    this.roleOther = '',
  });

  final String firstName;
  final String lastName;
  final String idNumber;
  final DateTime? birthDate;
  final String role;
  final String roleOther;

  @override
  List<Object?> get props => [firstName, lastName, idNumber, birthDate, role, roleOther];
}

final class CompanyBusiness extends CompanySection {
  const CompanyBusiness({
    this.accountName = '',
    this.companyName = '',
    this.branch = '',
    this.accountNameSource = AccountNameSource.company,
    this.wilaya = '',
    this.address = '',
    this.registrationNumber = '',
    this.ns = '',
    this.nif = '',
    this.capital,
  });

  final String accountName;
  final String companyName;
  final String branch;
  final AccountNameSource accountNameSource;
  final String wilaya;
  final String address;
  final String registrationNumber;
  final String ns;
  final String nif;
  final int? capital;

  @override
  List<Object?> get props =>
      [accountName, companyName, branch, accountNameSource, wilaya, address, registrationNumber, ns, nif, capital];
}

class MarketingPage extends Equatable {
  const MarketingPage({required this.url, this.platform = SocialPlatform.website, this.username = ''});

  final String url;
  final SocialPlatform platform;
  final String username;

  @override
  List<Object?> get props => [url];
}

final class CompanyPresence extends CompanySection {
  const CompanyPresence({
    this.bio = '',
    this.activityAreas = const [],
    this.activityOther = '',
    this.marketingPages = const [],
  });

  final String bio;
  final List<String> activityAreas;
  final String activityOther;
  final List<MarketingPage> marketingPages;

  @override
  List<Object?> get props => [bio, activityAreas, activityOther, marketingPages];
}

final class CompanyContact extends CompanySection {
  const CompanyContact({this.phone = '', this.whatsapp = '', this.phone2 = '', this.email = ''});

  final String phone;
  final String whatsapp;
  final String phone2;
  final String email;

  @override
  List<Object?> get props => [phone, whatsapp, phone2, email];
}

final class CompanyConsents extends CompanySection {
  const CompanyConsents({this.acceptedTerms = false, this.acceptedPrivacy = false});

  final bool acceptedTerms;
  final bool acceptedPrivacy;

  bool get all => acceptedTerms && acceptedPrivacy;

  @override
  List<Object?> get props => [acceptedTerms, acceptedPrivacy];
}

class CompanyProfile extends Equatable {
  const CompanyProfile({
    required this.id,
    required this.status,
    this.businessType,
    this.personal = const CompanyPersonal(),
    this.business = const CompanyBusiness(),
    this.presence = const CompanyPresence(),
    this.contact = const CompanyContact(),
    this.consents = const CompanyConsents(),
    this.displayName = '',
    this.profileImageUrl,
    this.submittedAt,
    this.updatedAt,
  });

  final int id;
  final BusinessType? businessType;
  final CompanyPersonal personal;
  final CompanyBusiness business;
  final CompanyPresence presence;
  final CompanyContact contact;
  final CompanyConsents consents;
  final String displayName;
  final String? profileImageUrl;
  final VerificationStatus status;
  final DateTime? submittedAt;
  final DateTime? updatedAt;

  bool get isEditable => status == VerificationStatus.draft || status == VerificationStatus.needsChanges;

  bool get isRegistered => businessType == BusinessType.registeredBusiness;

  bool hasSaved(CompanySection section) => switch (section) {
        CompanyPersonal() => section == personal,
        CompanyBusiness() => section == business,
        CompanyPresence() => section == presence,
        CompanyContact() => section == contact,
        CompanyConsents() => section == consents,
      };

  CompanyProfile withoutImage() => CompanyProfile(
        id: id,
        status: status,
        businessType: businessType,
        personal: personal,
        business: business,
        presence: presence,
        contact: contact,
        consents: consents,
        displayName: displayName,
        submittedAt: submittedAt,
        updatedAt: DateTime.now(),
      );

  @override
  List<Object?> get props => [
        id,
        businessType,
        personal,
        business,
        presence,
        contact,
        consents,
        displayName,
        profileImageUrl,
        status,
        submittedAt,
        updatedAt,
      ];
}

class ScannedBusiness extends Equatable {
  const ScannedBusiness({
    this.registrationNumber = '',
    this.companyName = '',
    this.address = '',
    this.wilaya = '',
    this.capital,
    this.ns = '',
    this.nif = '',
    this.title = '',
  });

  final String registrationNumber;
  final String companyName;
  final String address;
  final String wilaya;
  final int? capital;
  final String ns;
  final String nif;
  final String title;

  bool get hasFields =>
      [registrationNumber, companyName, address, wilaya, ns, nif].any((v) => v.isNotEmpty) || capital != null;

  @override
  List<Object?> get props => [registrationNumber, companyName, address, wilaya, capital, ns, nif, title];
}

class CompanyDocument extends Equatable {
  const CompanyDocument({
    required this.id,
    required this.type,
    required this.downloadUrl,
    this.fileName = '',
    this.description = '',
    this.financialAccountId,
    this.check = DocumentCheck.notChecked,
    this.scanned = const ScannedFields(),
    this.business = const ScannedBusiness(),
    this.review = DocumentReview.pending,
    this.reviewReason = '',
  });

  final int id;
  final CompanyDocumentType type;
  final String fileName;
  final String description;
  final int? financialAccountId;
  final DocumentCheck check;
  final ScannedFields scanned;
  final ScannedBusiness business;
  final DocumentReview review;
  final String reviewReason;
  final String downloadUrl;

  @override
  List<Object?> get props =>
      [id, type, fileName, description, financialAccountId, check, scanned, business, review, reviewReason, downloadUrl];
}

class CompanyBundle extends Equatable {
  const CompanyBundle({this.profile, this.documents = const [], this.financialAccounts = const []});

  final CompanyProfile? profile;
  final List<CompanyDocument> documents;
  final List<FinancialAccount> financialAccounts;

  @override
  List<Object?> get props => [profile, documents, financialAccounts];
}
