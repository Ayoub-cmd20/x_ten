import 'package:equatable/equatable.dart';
import 'package:x_ten/core/catalog/influencer_categories.dart';
import 'package:x_ten/core/enums/verification_status.dart';

export 'package:x_ten/core/utils/upload_file.dart';

T enumFromApi<T extends Enum>(List<T> values, String? value, T fallback) =>
    values.firstWhere((e) => e.name == value, orElse: () => fallback);

T? maybeEnum<T extends Enum>(List<T> values, String? value) => values.where((e) => e.name == value).firstOrNull;

enum EntityType { natural, legal }

enum LanguageLevel { basic, good, advanced }

enum FinancialKind { ccp, bank, other }

enum SocialPlatform { facebook, instagram, tiktok, youtube, snapchat, x, linkedin, telegram, website, blog, other }

enum SocialSource { auto, manual, screenshot }

enum FacebookAccountType { profile, page }

enum DocumentType { identityFront, identityBack, passport, ccpCheque, bankRib, financialProof, other }

enum DocumentCheck { notChecked, passed, needsManualReview }

enum IdentityKind { idCard, passport }

enum MeetingStatus { scheduled, completed, noShow, cancelled, unknown }


abstract final class RegistrationCatalog {
  static const categories = InfluencerCategories.ids;
  static const maxPrimaryCategories = 3;
  static const maxSecondaryCategories = 3;

  static const languages = ['arabic', 'darija', 'amazigh', 'english', 'french', 'other'];
  static const otherLanguage = 'other';
  static const maxAddressLanguages = 5;


  static const adContentTypes = [
    'review',
    'testTry',
    'unboxing',
    'tutorial',
    'personalRecommendation',
    'directCta',
    'storytelling',
    'productPlacement',
    'comparison',
    'tipsTricks',
    'polls',
    'dailyVlog',
    'challenges',
    'affiliateLinks',
    'giveaways',
    'inspiringStories',
    'podcast',
    'motivationalPosts',
  ];
  static const maxAdContentTypes = 4;

  static const levelPercent = {LanguageLevel.basic: 33, LanguageLevel.good: 66, LanguageLevel.advanced: 100};

  static const nationalIdLength = 18;
  static const defaultCountry = 'DZ';

  static const financialInstitutions = [
    'algeriePoste',
    'bna',
    'bea',
    'bdl',
    'badr',
    'cpa',
    'cnep',
    'bnh',
    'agb',
    'societeGenerale',
    'bnpParibas',
    'bankAbc',
    'housingBank',
    'alSalam',
    'alBaraka',
    'fransabank',
    'arabBank',
  ];


  static const audienceRegions = [
    'north', 'northEast', 'northWest', 'center', 'centerEast', 'centerWest', 'south', 'southEast', 'southWest',
  ];
  static const audienceGenders = ['male', 'female', 'unspecified'];
  static const audienceAges = ['under18', '18-24', '25-34', '35-44', '45-54', '55+'];
  static const audienceLanguages = ['arabic', 'amazigh', 'english', 'french', 'mixed'];
  static const audienceContent = ['video', 'photo', 'stories', 'live', 'written', 'audio', 'interactive'];
  static const audiencePlatforms = ['facebook', 'instagram', 'tiktok', 'youtube', 'snapchat', 'x', 'linkedin', 'telegram', 'other'];
  static const maxTopPlatforms = 3;
  static const weekDays = ['sat', 'sun', 'mon', 'tue', 'wed', 'thu', 'fri'];

  static const identityDocuments = {DocumentType.identityFront, DocumentType.passport};

 
  static const insightsPlatforms = ['instagram', 'facebook', 'tiktok', 'youtube'];

  static const maxScanAttempts = 3;
}

bool totals100(Map<String, double> shares) {
  final values = shares.values.where((v) => v > 0);
  if (values.isEmpty) return true;
  return (values.fold<double>(0, (sum, v) => sum + v) - 100).abs() <= 0.01;
}

sealed class RegistrationSection extends Equatable {
  const RegistrationSection();
}

class PersonalInfo extends RegistrationSection {
  const PersonalInfo({
    required this.firstName,
    required this.lastName,
    required this.birthPlace,
    this.nationalId = '',
    this.birthDate,
    this.entityType,
  });

  final String firstName;
  final String lastName;
  final String nationalId;
  final DateTime? birthDate;
  final String birthPlace;
  final EntityType? entityType;

  bool get isComplete =>
      firstName.isNotEmpty &&
      lastName.isNotEmpty &&
      nationalId.length == RegistrationCatalog.nationalIdLength &&
      birthDate != null &&
      birthPlace.isNotEmpty &&
      entityType != null;

  @override
  List<Object?> get props => [firstName, lastName, nationalId, birthDate, birthPlace, entityType];
}

class ContentLanguage extends Equatable {
  const ContentLanguage({required this.code, required this.level, this.name = ''});

  final String code;
  final LanguageLevel level;
  final String name;

  int get percent => RegistrationCatalog.levelPercent[level]!;

  @override
  List<Object?> get props => [code, level, name];
}

class ProfileInfo extends RegistrationSection {
  const ProfileInfo({
    required this.displayName,
    required this.primaryCategories,
    required this.secondaryCategories,
    required this.contentLanguages,
    required this.addressLanguages,
  });

  final String displayName;
  final List<String> primaryCategories;
  final List<String> secondaryCategories;
  final List<ContentLanguage> contentLanguages;


  final List<String> addressLanguages;

  bool get isComplete =>
      displayName.isNotEmpty &&
      primaryCategories.isNotEmpty &&
      contentLanguages.isNotEmpty &&
      addressLanguages.isNotEmpty;

  @override
  List<Object?> get props =>
      [displayName, primaryCategories, secondaryCategories, contentLanguages, addressLanguages];
}

class ContactInfo extends RegistrationSection {
  const ContactInfo({
    required this.phone,
    required this.whatsapp,
    required this.email,
    this.backupPhone = '',
    this.deliveryAddress = '',
  });

  final String phone;
  final String whatsapp;
  final String email;
  final String backupPhone;
  final String deliveryAddress;

  bool get isComplete => phone.isNotEmpty && whatsapp.isNotEmpty && email.isNotEmpty;

  @override
  List<Object?> get props => [phone, whatsapp, email, backupPhone, deliveryAddress];
}

class ConsentInfo extends RegistrationSection {
  const ConsentInfo({this.acceptedTerms = false, this.acceptedPrivacy = false});

  final bool acceptedTerms;
  final bool acceptedPrivacy;

  bool get all => acceptedTerms && acceptedPrivacy;

  @override
  List<Object?> get props => [acceptedTerms, acceptedPrivacy];
}

class CountryShare extends Equatable {
  const CountryShare({required this.country, required this.percent, this.regions = const {}});

  final String country;
  final double percent;
  final Map<String, double> regions;

  @override
  List<Object?> get props => [country, percent, regions];
}


class Audience extends Equatable {
  const Audience({
    this.countries = const [],
    this.gender = const {},
    this.ages = const {},
    this.languages = const {},
    this.topPlatforms = const [],
    this.activityDays = const [],
    this.fromHour = '',
    this.toHour = '',
    this.contentEngagement = const [],
  });

  final List<CountryShare> countries;
  final Map<String, double> gender;
  final Map<String, double> ages;
  final Map<String, double> languages;
  final List<String> topPlatforms;
  final List<String> activityDays;
  final String fromHour;
  final String toHour;
  final List<String> contentEngagement;

  Map<String, double> get countryShares => {for (final c in countries) c.country: c.percent};


  Audience overlay(Audience scan) => Audience(
        countries: scan.countries.isNotEmpty ? scan.countries : countries,
        gender: scan.gender.isNotEmpty ? scan.gender : gender,
        ages: scan.ages.isNotEmpty ? scan.ages : ages,
        languages: scan.languages.isNotEmpty ? scan.languages : languages,
        topPlatforms: topPlatforms,
        activityDays: activityDays,
        fromHour: fromHour,
        toHour: toHour,
        contentEngagement: scan.contentEngagement.isNotEmpty ? scan.contentEngagement : contentEngagement,
      );

 
  int get filledGroups => [
        countries.isNotEmpty,
        countries.any((c) => c.regions.isNotEmpty),
        gender.isNotEmpty,
        ages.isNotEmpty,
        languages.isNotEmpty,
        contentEngagement.isNotEmpty,
      ].where((filled) => filled).length;


  List<String> get unbalanced => [
        if (!totals100(countryShares)) 'countries',
        if (countries.any((c) => !totals100(c.regions))) 'regions',
        if (!totals100(gender)) 'gender',
        if (!totals100(ages)) 'ages',
        if (!totals100(languages)) 'languages',
      ];

  bool get isEmpty =>
      countries.isEmpty &&
      gender.isEmpty &&
      ages.isEmpty &&
      languages.isEmpty &&
      topPlatforms.isEmpty &&
      activityDays.isEmpty &&
      contentEngagement.isEmpty;

  @override
  List<Object?> get props => [
        countries,
        gender,
        ages,
        languages,
        topPlatforms,
        activityDays,
        fromHour,
        toHour,
        contentEngagement,
      ];
}

class OptionalInfo extends RegistrationSection {
  const OptionalInfo({this.bio = '', this.audience = const Audience(), this.contentTypes = const []});

  final String bio;
  final Audience audience;
  final List<String> contentTypes;

  @override
  List<Object?> get props => [bio, audience, contentTypes];
}


class Registration extends Equatable {
  const Registration({
    required this.id,
    required this.isCurrent,
    required this.personal,
    required this.profile,
    required this.contact,
    required this.optional,
    required this.status,
    this.consents = const ConsentInfo(),
    this.country = '',
    this.profileImageUrl,
    this.submittedAt,
    this.updatedAt,
  });

  final int id;
  final bool isCurrent;
  final PersonalInfo personal;
  final ProfileInfo profile;
  final ContactInfo contact;
  final OptionalInfo optional;
  final ConsentInfo consents;
  final String country;
  final VerificationStatus status;
  final String? profileImageUrl;
  final DateTime? submittedAt;
  final DateTime? updatedAt;

  bool get isEditable => status == VerificationStatus.draft || status == VerificationStatus.needsChanges;


  bool hasSaved(RegistrationSection section) => switch (section) {
        final PersonalInfo value => value == personal,
        final ProfileInfo value => value == profile,
        final ContactInfo value => value == contact,
        final OptionalInfo value => value == optional,
        final ConsentInfo value => value == consents,
      };

  bool get canEditOptional => isCurrent && status != VerificationStatus.rejected;

  Registration copyWith({Object? profileImageUrl = _keep, DateTime? updatedAt}) => Registration(
        id: id,
        isCurrent: isCurrent,
        personal: personal,
        profile: profile,
        contact: contact,
        optional: optional,
        consents: consents,
        country: country,
        status: status,
        profileImageUrl: identical(profileImageUrl, _keep) ? this.profileImageUrl : profileImageUrl as String?,
        submittedAt: submittedAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  static const _keep = Object();

  @override
  List<Object?> get props => [
        id,
        isCurrent,
        personal,
        profile,
        contact,
        optional,
        consents,
        country,
        status,
        profileImageUrl,
        submittedAt,
        updatedAt,
      ];
}

class SocialAccount extends Equatable {
  const SocialAccount({
    required this.id,
    required this.platform,
    required this.url,
    this.accountName = '',
    this.username = '',
    this.facebookAccountType,
    this.followers = 0,
    this.avatarUrl = '',
    this.source = SocialSource.manual,
    this.lastSyncedAt,
    this.verified = false,
    this.hasScreenshot = false,
  });

  final int id;
  final SocialPlatform platform;
  final FacebookAccountType? facebookAccountType;
  final String url;
  final String accountName;
  final String username;
  final int followers;
  final String avatarUrl;

 
  final SocialSource source;
  final DateTime? lastSyncedAt;
  final bool verified;


  final bool hasScreenshot;

  bool get isAuto => source == SocialSource.auto;

  bool get fromScreenshot => source == SocialSource.screenshot;


  bool get needsDetails => !isAuto && (accountName.isEmpty || followers == 0);

  @override
  List<Object?> get props =>
      [
        id,
        platform,
        facebookAccountType,
        url,
        accountName,
        username,
        followers,
        avatarUrl,
        source,
        lastSyncedAt,
        verified,
        hasScreenshot,
      ];
}

class PortfolioItem extends Equatable {
  const PortfolioItem({
    required this.title,
    this.description = '',
    this.link = '',
    this.id = 0,
    this.fileName = '',
    this.fileUrl,
  });

  final int id;
  final String title;
  final String description;
  final String link;
  final String fileName;
  final String? fileUrl;

  @override
  List<Object?> get props => [id, title, description, link, fileName, fileUrl];
}

class FinancialAccount extends Equatable {
  const FinancialAccount({
    required this.accountNumber,
    this.kind = FinancialKind.other,
    this.id = 0,
    this.institutionName = '',
    this.accountKey = '',
    this.keyValid,
  });

  final int id;

  
  final FinancialKind kind;
  final String institutionName;
  final String accountNumber;
  final String accountKey;


  final bool? keyValid;

  @override
  List<Object?> get props => [id, kind, institutionName, accountNumber, accountKey, keyValid];
}


class ScannedFields extends Equatable {
  const ScannedFields({
    this.firstName = '',
    this.lastName = '',
    this.idNumber = '',
    this.nationalId = '',
    this.birthDate,
    this.birthPlace = '',
  });

  final String firstName;
  final String lastName;
  final String idNumber;
  final String nationalId;
  final DateTime? birthDate;
  final String birthPlace;

  bool get hasIdentity =>
      firstName.isNotEmpty ||
      lastName.isNotEmpty ||
      idNumber.isNotEmpty ||
      nationalId.isNotEmpty ||
      birthDate != null ||
      birthPlace.isNotEmpty;

  @override
  List<Object?> get props => [firstName, lastName, idNumber, nationalId, birthDate, birthPlace];
}

class RegistrationDocument extends Equatable {
  const RegistrationDocument({
    required this.id,
    required this.type,
    required this.fileName,
    required this.verified,
    required this.downloadUrl,
    this.financialAccountId,
    this.check = DocumentCheck.notChecked,
    this.scanned = const ScannedFields(),
    this.createdAt,
  });

  final int id;
  final DocumentType type;
  final int? financialAccountId;
  final String fileName;
  final bool verified;
  final DocumentCheck check;
  final ScannedFields scanned;
  final String downloadUrl;
  final DateTime? createdAt;

  @override
  List<Object?> get props =>
      [id, type, financialAccountId, fileName, verified, check, scanned, downloadUrl, createdAt];
}

class VerificationMeeting extends Equatable {
  const VerificationMeeting({
    required this.id,
    required this.contextId,
    required this.scheduledAt,
    required this.status,
  });

  final int id;
  final int contextId;
  final DateTime scheduledAt;
  final MeetingStatus status;

  @override
  List<Object?> get props => [id, contextId, scheduledAt, status];
}

class RegistrationBundle extends Equatable {
  const RegistrationBundle({
    this.registration,
    this.socialAccounts = const [],
    this.portfolio = const [],
    this.financialAccounts = const [],
    this.documents = const [],
    this.meeting,
  });

  final Registration? registration;
  final List<SocialAccount> socialAccounts;
  final List<PortfolioItem> portfolio;
  final List<FinancialAccount> financialAccounts;
  final List<RegistrationDocument> documents;
  final VerificationMeeting? meeting;

  @override
  List<Object?> get props => [registration, socialAccounts, portfolio, financialAccounts, documents, meeting];
}
