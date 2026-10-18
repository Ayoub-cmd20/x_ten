import 'package:equatable/equatable.dart';
import 'package:x_ten/core/enums/verification_status.dart';

T enumFromApi<T extends Enum>(List<T> values, String? value, T fallback) =>
    values.firstWhere((e) => e.name == value, orElse: () => fallback);

enum FinancialAccountType { ccp, bank, both }

enum SocialPlatform { facebook, instagram, tiktok, youtube, snapchat, x, linkedin, website, blog, other }

enum FacebookAccountType { profile, page }

enum DocumentType { identityFront, identityBack, ccpCheque, bankRib, other }

enum MeetingStatus { scheduled, completed, noShow, cancelled, unknown }

abstract final class RegistrationCatalog {
  static const ageGroups = ['13-17', '18-24', '25-34', '35-44', '45+'];

  static const categories = [
    'technology',
    'gaming',
    'sports',
    'football',
    'fitness',
    'health',
    'beauty',
    'fashion',
    'lifestyle',
    'cooking',
    'travel',
    'cars',
    'education',
    'business',
    'finance',
    'marketing',
    'ecommerce',
    'art',
    'music',
    'entertainment',
    'family',
    'photography',
  ];

  static const contentTypes = ['post', 'reel', 'story', 'video', 'live', 'podcast', 'review', 'tutorial'];

  static const wilayas = [
    'Adrar', 'Chlef', 'Laghouat', 'Oum El Bouaghi', 'Batna', 'Béjaïa', 'Biskra', 'Béchar',
    'Blida', 'Bouira', 'Tamanrasset', 'Tébessa', 'Tlemcen', 'Tiaret', 'Tizi Ouzou', 'Alger',
    'Djelfa', 'Jijel', 'Sétif', 'Saïda', 'Skikda', 'Sidi Bel Abbès', 'Annaba', 'Guelma',
    'Constantine', 'Médéa', 'Mostaganem', "M'Sila", 'Mascara', 'Ouargla', 'Oran', 'El Bayadh',
    'Illizi', 'Bordj Bou Arréridj', 'Boumerdès', 'El Tarf', 'Tindouf', 'Tissemsilt', 'El Oued',
    'Khenchela', 'Souk Ahras', 'Tipaza', 'Mila', 'Aïn Defla', 'Naâma', 'Aïn Témouchent',
    'Ghardaïa', 'Relizane', 'Timimoun', 'Bordj Badji Mokhtar', 'Ouled Djellal', 'Béni Abbès',
    'In Salah', 'In Guezzam', 'Touggourt', 'Djanet', "El M'Ghair", 'El Meniaa',
  ];

  static List<DocumentType> requiredDocuments(FinancialAccountType? type) => [
        DocumentType.identityFront,
        DocumentType.identityBack,
        if (type == FinancialAccountType.ccp || type == FinancialAccountType.both) DocumentType.ccpCheque,
        if (type == FinancialAccountType.bank || type == FinancialAccountType.both) DocumentType.bankRib,
      ];
}

class BasicInfo extends Equatable {
  const BasicInfo({
    required this.firstName,
    required this.lastName,
    required this.displayName,
    required this.birthPlace,
    required this.bio,
    required this.skills,
    required this.whatsapp,
    this.birthDate,
  });

  final String firstName;
  final String lastName;
  final String displayName;
  final DateTime? birthDate;
  final String birthPlace;
  final String bio;
  final String skills;
  final String whatsapp;

  @override
  List<Object?> get props => [firstName, lastName, displayName, birthDate, birthPlace, bio, skills, whatsapp];
}

class Audience extends Equatable {
  const Audience({
    required this.ageDistribution,
    required this.malePercentage,
    required this.femalePercentage,
    required this.locations,
    required this.interests,
  });

  final Map<String, double> ageDistribution;
  final double malePercentage;
  final double femalePercentage;
  final Map<String, double> locations;
  final List<String> interests;

  double get ageTotal => ageDistribution.values.fold(0, (sum, value) => sum + value);

  bool get isBalanced => (ageTotal - 100).abs() <= 0.01 && (malePercentage + femalePercentage - 100).abs() <= 0.01;

  @override
  List<Object?> get props => [ageDistribution, malePercentage, femalePercentage, locations, interests];
}

class ProfileInfo extends Equatable {
  const ProfileInfo({
    required this.primaryCategories,
    required this.secondaryCategories,
    required this.contentTypes,
    required this.audience,
  });

  final List<String> primaryCategories;
  final List<String> secondaryCategories;
  final List<String> contentTypes;
  final Audience audience;

  @override
  List<Object?> get props => [primaryCategories, secondaryCategories, contentTypes, audience];
}

class FinancialInfo extends Equatable {
  const FinancialInfo({
    required this.accountType,
    this.ccpAccount = '',
    this.ccpKey = '',
    this.bankName = '',
    this.bankAccount = '',
    this.rib = '',
  });

  final FinancialAccountType accountType;
  final String ccpAccount;
  final String ccpKey;
  final String bankName;
  final String bankAccount;
  final String rib;

  bool get usesCcp => accountType != FinancialAccountType.bank;

  bool get usesBank => accountType != FinancialAccountType.ccp;

  @override
  List<Object?> get props => [accountType, ccpAccount, ccpKey, bankName, bankAccount, rib];
}

class NotificationPreferences extends Equatable {
  const NotificationPreferences({
    this.inApp = true,
    this.sms = false,
    this.phoneCall = false,
    this.email = true,
    this.whatsapp = true,
  });

  final bool inApp;
  final bool sms;
  final bool phoneCall;
  final bool email;
  final bool whatsapp;

  NotificationPreferences copyWith({bool? inApp, bool? sms, bool? phoneCall, bool? email, bool? whatsapp}) =>
      NotificationPreferences(
        inApp: inApp ?? this.inApp,
        sms: sms ?? this.sms,
        phoneCall: phoneCall ?? this.phoneCall,
        email: email ?? this.email,
        whatsapp: whatsapp ?? this.whatsapp,
      );

  @override
  List<Object?> get props => [inApp, sms, phoneCall, email, whatsapp];
}

class Consents extends Equatable {
  const Consents({
    this.confirmInformation = false,
    this.acceptedTerms = false,
    this.acceptedPrivacy = false,
    this.acceptedVerification = false,
    this.acceptedContact = false,
  });

  final bool confirmInformation;
  final bool acceptedTerms;
  final bool acceptedPrivacy;
  final bool acceptedVerification;
  final bool acceptedContact;

  bool get all => confirmInformation && acceptedTerms && acceptedPrivacy && acceptedVerification && acceptedContact;

  Consents copyWith({
    bool? confirmInformation,
    bool? acceptedTerms,
    bool? acceptedPrivacy,
    bool? acceptedVerification,
    bool? acceptedContact,
  }) =>
      Consents(
        confirmInformation: confirmInformation ?? this.confirmInformation,
        acceptedTerms: acceptedTerms ?? this.acceptedTerms,
        acceptedPrivacy: acceptedPrivacy ?? this.acceptedPrivacy,
        acceptedVerification: acceptedVerification ?? this.acceptedVerification,
        acceptedContact: acceptedContact ?? this.acceptedContact,
      );

  @override
  List<Object?> get props => [confirmInformation, acceptedTerms, acceptedPrivacy, acceptedVerification, acceptedContact];
}

class Registration extends Equatable {
  const Registration({
    required this.id,
    required this.attemptNumber,
    required this.isCurrent,
    required this.basic,
    required this.email,
    required this.phone,
    required this.primaryCategories,
    required this.secondaryCategories,
    required this.contentTypes,
    required this.consents,
    required this.status,
    this.profileImageUrl,
    this.audience,
    this.financial,
    this.submittedAt,
    this.updatedAt,
  });

  final int id;
  final int attemptNumber;
  final bool isCurrent;
  final BasicInfo basic;
  final String email;
  final String phone;
  final String? profileImageUrl;
  final List<String> primaryCategories;
  final List<String> secondaryCategories;
  final List<String> contentTypes;
  final Audience? audience;
  final FinancialInfo? financial;
  final Consents consents;
  final VerificationStatus status;
  final DateTime? submittedAt;
  final DateTime? updatedAt;

  bool get isDraft => status == VerificationStatus.draft;

  bool get canStartNewAttempt => status == VerificationStatus.needsChanges || status == VerificationStatus.rejected;

  ProfileInfo? get profile => switch (audience) {
        final audience? => ProfileInfo(
            primaryCategories: primaryCategories,
            secondaryCategories: secondaryCategories,
            contentTypes: contentTypes,
            audience: audience,
          ),
        null => null,
      };

  @override
  List<Object?> get props => [
        id,
        attemptNumber,
        isCurrent,
        basic,
        email,
        phone,
        profileImageUrl,
        primaryCategories,
        secondaryCategories,
        contentTypes,
        audience,
        financial,
        consents,
        status,
        submittedAt,
        updatedAt,
      ];
}

class SocialAccount extends Equatable {
  const SocialAccount({
    required this.platform,
    required this.url,
    required this.accountName,
    required this.username,
    this.id = 0,
    this.facebookAccountType,
    this.description = '',
    this.followers = 0,
    this.avatarUrl = '',
    this.verified = false,
  });

  final int id;
  final SocialPlatform platform;
  final FacebookAccountType? facebookAccountType;
  final String url;
  final String accountName;
  final String username;
  final String description;
  final int followers;
  final String avatarUrl;
  final bool verified;

  @override
  List<Object?> get props =>
      [id, platform, facebookAccountType, url, accountName, username, description, followers, avatarUrl, verified];
}

class PortfolioItem extends Equatable {
  const PortfolioItem({
    required this.title,
    required this.description,
    required this.link,
    this.id = 0,
    this.mediaUrls = const [],
  });

  final int id;
  final String title;
  final String description;
  final String link;
  final List<String> mediaUrls;

  @override
  List<Object?> get props => [id, title, description, link, mediaUrls];
}

class RegistrationDocument extends Equatable {
  const RegistrationDocument({
    required this.id,
    required this.type,
    required this.fileName,
    required this.verified,
    required this.downloadUrl,
    this.createdAt,
  });

  final int id;
  final DocumentType type;
  final String fileName;
  final bool verified;
  final String downloadUrl;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [id, type, fileName, verified, downloadUrl, createdAt];
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

class UploadFile extends Equatable {
  const UploadFile({required this.path, required this.name, required this.size});

  final String path;
  final String name;
  final int size;

  @override
  List<Object?> get props => [path, name, size];
}

class RegistrationBundle extends Equatable {
  const RegistrationBundle({
    this.registration,
    this.socialAccounts = const [],
    this.portfolio = const [],
    this.documents = const [],
    this.meeting,
  });

  final Registration? registration;
  final List<SocialAccount> socialAccounts;
  final List<PortfolioItem> portfolio;
  final List<RegistrationDocument> documents;
  final VerificationMeeting? meeting;

  @override
  List<Object?> get props => [registration, socialAccounts, portfolio, documents, meeting];
}
