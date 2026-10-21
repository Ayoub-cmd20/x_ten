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

/// القوائم الثابتة: منقولة من وثائق صاحب المشروع (نفس المعرّفات في الباك إند).
abstract final class RegistrationCatalog {
  static const categories = InfluencerCategories.ids;
  static const maxPrimaryCategories = 3;
  static const maxSecondaryCategories = 3;

  static const languages = ['arabic', 'darija', 'amazigh', 'english', 'french', 'other'];
  static const otherLanguage = 'other';
  static const maxAddressLanguages = 5;

  /// أنواع المحتوى الإعلاني (تترتب حسب الأولوية)
  static const adContentTypes = [
    'review',
    'testTry',
    'unboxing',
    'tutorial',
    'personalRecommendation',
    'directCta',
    'storytelling',
    'productPlacement',
  ];

  /// المهارات: المجموعات 1، 2، 3، 6 من وثيقة المهارات
  static const skillGroups = <String, List<String>>{
    'core': [
      'copywriting', 'storytelling', 'onCamera', 'acting', 'voiceOver',
      'productReviews', 'educational', 'motivational', 'comedy', 'dailyLife',
    ],
    'production': ['videoShooting', 'photography', 'videoEditing', 'photoEditing', 'directing', 'lighting', 'audioSetup'],
    'marketing': ['adIntegration', 'indirectPromotion', 'effectiveCta', 'brandIdentity', 'briefCompliance'],
    'advanced': ['campaignManagement', 'adScripting', 'performanceAnalysis', 'contentRepurposing', 'multilingual'],
  };
  static const minSkills = 3;
  static const maxSkills = 7;

  static const audienceRegions = [
    'north', 'northEast', 'northWest', 'center', 'centerEast', 'centerWest', 'south', 'southEast', 'southWest',
  ];
  static const audienceGenders = ['male', 'female', 'unspecified'];
  static const audienceAges = ['under18', '18-24', '25-34', '35-44', '45-54', '55+'];
  static const audienceLanguages = ['arabic', 'amazigh', 'english', 'french', 'mixed'];
  static const audienceContent = ['video', 'photo', 'stories', 'live'];
  static const audiencePlatforms = ['facebook', 'instagram', 'tiktok', 'youtube', 'snapchat', 'x', 'linkedin', 'telegram', 'other'];
  static const maxTopPlatforms = 3;
  static const weekDays = ['sat', 'sun', 'mon', 'tue', 'wed', 'thu', 'fri'];
  static const purchasingPower = ['low', 'medium', 'high'];

  static const identityDocuments = {DocumentType.identityFront, DocumentType.identityBack, DocumentType.passport};

  /// اللقطات المقبولة لـ Insights
  static const insightsPlatforms = ['instagram', 'facebook', 'tiktok', 'youtube'];

  /// بعدها تتقبل الوثيقة وتتراجع يدوياً في الاجتماع
  static const maxScanAttempts = 3;
}

bool totals100(Map<String, double> shares) {
  final values = shares.values.where((v) => v > 0);
  if (values.isEmpty) return true;
  return (values.fold<double>(0, (sum, v) => sum + v) - 100).abs() <= 0.01;
}

// ---------- أقسام التسجيل ----------

/// كل قسم يتحفظ وحدو (PATCH). المعلومات الشخصية تنشئ الملف أول مرة.
sealed class RegistrationSection extends Equatable {
  const RegistrationSection();
}

class PersonalInfo extends RegistrationSection {
  const PersonalInfo({
    required this.firstName,
    required this.lastName,
    required this.birthPlace,
    this.birthDate,
    this.entityType,
  });

  final String firstName;
  final String lastName;
  final DateTime? birthDate;
  final String birthPlace;
  final EntityType? entityType;

  bool get isComplete =>
      firstName.isNotEmpty && lastName.isNotEmpty && birthDate != null && birthPlace.isNotEmpty && entityType != null;

  @override
  List<Object?> get props => [firstName, lastName, birthDate, birthPlace, entityType];
}

class ContentLanguage extends Equatable {
  const ContentLanguage({required this.code, required this.level, this.name = ''});

  final String code;
  final LanguageLevel level;

  /// اسم اللغة لما تكون "أخرى"
  final String name;

  @override
  List<Object?> get props => [code, level, name];
}

class ProfileInfo extends RegistrationSection {
  const ProfileInfo({
    required this.displayName,
    required this.primaryCategories,
    required this.secondaryCategories,
    required this.bio,
    required this.contentLanguages,
    required this.addressLanguages,
  });

  final String displayName;
  final List<String> primaryCategories;
  final List<String> secondaryCategories;
  final String bio;
  final List<ContentLanguage> contentLanguages;

  /// ترتيب لغات الخطاب المفضلة (تنبيه للمعلن)
  final List<String> addressLanguages;

  bool get isComplete =>
      displayName.isNotEmpty &&
      primaryCategories.isNotEmpty &&
      bio.isNotEmpty &&
      contentLanguages.isNotEmpty &&
      addressLanguages.isNotEmpty;

  @override
  List<Object?> get props =>
      [displayName, primaryCategories, secondaryCategories, bio, contentLanguages, addressLanguages];
}

class ContactInfo extends RegistrationSection {
  const ContactInfo({required this.phone, required this.whatsapp, required this.email});

  final String phone;
  final String whatsapp;
  final String email;

  bool get isComplete => phone.isNotEmpty && whatsapp.isNotEmpty && email.isNotEmpty;

  @override
  List<Object?> get props => [phone, whatsapp, email];
}

class CountryShare extends Equatable {
  const CountryShare({required this.country, required this.percent});

  final String country;
  final double percent;

  @override
  List<Object?> get props => [country, percent];
}

/// حصر الجمهور: كل قسم اختياري، بصح لو يتعمّر مجموعه لازم 100%.
class Audience extends Equatable {
  const Audience({
    this.countries = const [],
    this.regions = const {},
    this.regionsUnspecified = false,
    this.gender = const {},
    this.ages = const {},
    this.languages = const {},
    this.topPlatforms = const [],
    this.activityDays = const [],
    this.fromHour = '',
    this.toHour = '',
    this.contentEngagement = const {},
    this.purchasingPower = '',
  });

  final List<CountryShare> countries;
  final Map<String, double> regions;
  final bool regionsUnspecified;
  final Map<String, double> gender;
  final Map<String, double> ages;
  final Map<String, double> languages;
  final List<String> topPlatforms;
  final List<String> activityDays;
  final String fromHour;
  final String toHour;
  final Map<String, double> contentEngagement;
  final String purchasingPower;

  Map<String, double> get countryShares => {for (final c in countries) c.country: c.percent};

  /// نتيجة القراءة الآلية فوق القيم الحالية: كل قسم تعمّر من اللقطة يعوّض القديم.
  Audience overlay(Audience scan) => Audience(
        countries: scan.countries.isNotEmpty ? scan.countries : countries,
        regions: scan.regions.isNotEmpty ? scan.regions : regions,
        regionsUnspecified: scan.regions.isNotEmpty ? false : regionsUnspecified,
        gender: scan.gender.isNotEmpty ? scan.gender : gender,
        ages: scan.ages.isNotEmpty ? scan.ages : ages,
        languages: scan.languages.isNotEmpty ? scan.languages : languages,
        topPlatforms: topPlatforms,
        activityDays: activityDays,
        fromHour: fromHour,
        toHour: toHour,
        contentEngagement: scan.contentEngagement.isNotEmpty ? scan.contentEngagement : contentEngagement,
        purchasingPower: purchasingPower,
      );

  /// عدد الأقسام اللي فيها قيم
  int get filledGroups => [
        countries.isNotEmpty,
        regions.isNotEmpty,
        gender.isNotEmpty,
        ages.isNotEmpty,
        languages.isNotEmpty,
        contentEngagement.isNotEmpty,
      ].where((filled) => filled).length;

  /// الأقسام اللي مجموعها ماشي 100
  List<String> get unbalanced => [
        if (!totals100(countryShares)) 'countries',
        if (!regionsUnspecified && !totals100(regions)) 'regions',
        if (!totals100(gender)) 'gender',
        if (!totals100(ages)) 'ages',
        if (!totals100(languages)) 'languages',
        if (!totals100(contentEngagement)) 'contentEngagement',
      ];

  bool get isEmpty =>
      countries.isEmpty &&
      regions.isEmpty &&
      !regionsUnspecified &&
      gender.isEmpty &&
      ages.isEmpty &&
      languages.isEmpty &&
      topPlatforms.isEmpty &&
      activityDays.isEmpty &&
      contentEngagement.isEmpty &&
      purchasingPower.isEmpty;

  @override
  List<Object?> get props => [
        countries,
        regions,
        regionsUnspecified,
        gender,
        ages,
        languages,
        topPlatforms,
        activityDays,
        fromHour,
        toHour,
        contentEngagement,
        purchasingPower,
      ];
}

/// الأقسام الاختيارية (تقدر تتكمّل حتى بعد التوثيق).
class OptionalInfo extends RegistrationSection {
  const OptionalInfo({this.audience = const Audience(), this.skills = const [], this.contentTypes = const []});

  final Audience audience;
  final List<String> skills;

  /// أنواع المحتوى الإعلاني مرتبة حسب الأولوية
  final List<String> contentTypes;

  @override
  List<Object?> get props => [audience, skills, contentTypes];
}

// ---------- الملف ----------

class Registration extends Equatable {
  const Registration({
    required this.id,
    required this.attemptNumber,
    required this.isCurrent,
    required this.personal,
    required this.profile,
    required this.contact,
    required this.optional,
    required this.status,
    this.profileImageUrl,
    this.submittedAt,
    this.updatedAt,
  });

  final int id;
  final int attemptNumber;
  final bool isCurrent;
  final PersonalInfo personal;
  final ProfileInfo profile;
  final ContactInfo contact;
  final OptionalInfo optional;
  final VerificationStatus status;
  final String? profileImageUrl;
  final DateTime? submittedAt;
  final DateTime? updatedAt;

  bool get isDraft => status == VerificationStatus.draft;

  /// القسم محفوظ بنفس القيم: ما نبعثوش PATCH
  bool hasSaved(RegistrationSection section) => switch (section) {
        final PersonalInfo value => value == personal,
        final ProfileInfo value => value == profile,
        final ContactInfo value => value == contact,
        final OptionalInfo value => value == optional,
      };

  bool get canStartNewAttempt => status == VerificationStatus.needsChanges || status == VerificationStatus.rejected;

  /// الأقسام الاختيارية تتعدّل حتى بعد الإرسال والتوثيق
  bool get canEditOptional => isCurrent && !canStartNewAttempt;

  Registration copyWith({Object? profileImageUrl = _keep, DateTime? updatedAt}) => Registration(
        id: id,
        attemptNumber: attemptNumber,
        isCurrent: isCurrent,
        personal: personal,
        profile: profile,
        contact: contact,
        optional: optional,
        status: status,
        profileImageUrl: identical(profileImageUrl, _keep) ? this.profileImageUrl : profileImageUrl as String?,
        submittedAt: submittedAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  static const _keep = Object();

  @override
  List<Object?> get props => [
        id,
        attemptNumber,
        isCurrent,
        personal,
        profile,
        contact,
        optional,
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

  /// auto: الاسم والصورة والمتابعين يتجددو وحدهم من المنصة
  final SocialSource source;
  final DateTime? lastSyncedAt;
  final bool verified;

  /// المتابعين مقروين من لقطة شاشة للبروفايل (تتراجع في الاجتماع)
  final bool hasScreenshot;

  bool get isAuto => source == SocialSource.auto;

  bool get fromScreenshot => source == SocialSource.screenshot;

  /// حساب يدوي ناقص: لازم يكمّل الاسم وعدد المتابعين
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

  /// يستنتجو السيرفر من الرقم واسم المؤسسة (للعرض فقط)
  final FinancialKind kind;
  final String institutionName;
  final String accountNumber;
  final String accountKey;

  /// RIB: المفتاح صحيح حسابياً؟ (ملاحظة فقط)
  final bool? keyValid;

  @override
  List<Object?> get props => [id, kind, institutionName, accountNumber, accountKey, keyValid];
}

/// الحقول اللي قراها السيرفر من الوثيقة (تعمّر الاستمارة، والمؤثر يراجع).
class ScannedFields extends Equatable {
  const ScannedFields({
    this.firstName = '',
    this.lastName = '',
    this.birthDate,
    this.birthPlace = '',
  });

  final String firstName;
  final String lastName;
  final DateTime? birthDate;
  final String birthPlace;

  bool get hasIdentity => firstName.isNotEmpty || lastName.isNotEmpty || birthDate != null || birthPlace.isNotEmpty;

  @override
  List<Object?> get props => [firstName, lastName, birthDate, birthPlace];
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

class FinancialScan extends Equatable {
  const FinancialScan({required this.account, required this.document});

  final FinancialAccount account;
  final RegistrationDocument document;

  @override
  List<Object?> get props => [account, document];
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
