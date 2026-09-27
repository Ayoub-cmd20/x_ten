import 'audience_profile.dart';
import 'content_type.dart';
import 'financial_information.dart';
import 'influencer_category_selection.dart';
import 'influencer_document.dart';
import 'notification_preferences.dart';
import 'social_account.dart';
import 'verification_status.dart';

class InfluencerRegistration {
  final String? id;

  // Personal
  final String firstName;
  final String lastName;
  final String displayName;

  final DateTime? birthDate;
  final String birthPlace;

  final String bio;
  final String skills;

  final String? profileImagePath;

  // Contact
  final String email;
  final String phone;
  final String whatsapp;

  // Categories
  final InfluencerCategorySelection
  categories;

  // Financial
  final FinancialInformation
  financialInformation;

  // Documents
  final List<InfluencerDocument>
  documents;

  // Social accounts
  final List<SocialAccount>
  socialAccounts;

  // Audience
  final AudienceProfile audience;

  // Content
  final List<ContentType>
  contentTypes;

  // Notifications
  final NotificationPreferences
  notificationPreferences;

  // Agreements
  final bool confirmInformation;
  final bool acceptedTerms;
  final bool acceptedPrivacy;
  final bool acceptedVerification;
  final bool acceptedContact;

  // Registration / verification
  final DateTime? registeredAt;

  final InfluencerVerificationStatus
  verificationStatus;

  const InfluencerRegistration({
    this.id,

    this.firstName = '',
    this.lastName = '',
    this.displayName = '',

    this.birthDate,
    this.birthPlace = '',

    this.bio = '',
    this.skills = '',

    this.profileImagePath,

    this.email = '',
    this.phone = '',
    this.whatsapp = '',

    this.categories =
    const InfluencerCategorySelection(),

    this.financialInformation =
    const FinancialInformation(),

    this.documents = const [],

    this.socialAccounts = const [],

    this.audience =
    const AudienceProfile(),

    this.contentTypes = const [],

    this.notificationPreferences =
    const NotificationPreferences(),

    this.confirmInformation = false,
    this.acceptedTerms = false,
    this.acceptedPrivacy = false,
    this.acceptedVerification = false,
    this.acceptedContact = false,

    this.registeredAt,

    this.verificationStatus =
        InfluencerVerificationStatus.draft,
  });

  String get fullName =>
      '$firstName $lastName'.trim();

  bool get termsCompleted =>
      confirmInformation &&
          acceptedTerms &&
          acceptedPrivacy &&
          acceptedVerification &&
          acceptedContact;

  bool get basicInformationCompleted =>
      firstName.trim().isNotEmpty &&
          lastName.trim().isNotEmpty &&
          displayName.trim().isNotEmpty &&
          birthDate != null &&
          birthPlace.trim().isNotEmpty &&
          email.trim().isNotEmpty &&
          phone.trim().isNotEmpty;

  bool get documentsCompleted {
    final identityFront =
    documents.any(
          (document) =>
      document.type ==
          InfluencerDocumentType
              .identityFront,
    );

    final identityBack =
    documents.any(
          (document) =>
      document.type ==
          InfluencerDocumentType
              .identityBack,
    );

    final financialDocument =
    documents.any(
          (document) =>
      document.type ==
          InfluencerDocumentType
              .bankRib ||
          document.type ==
              InfluencerDocumentType
                  .ccpCheque,
    );

    return identityFront &&
        identityBack &&
        financialDocument;
  }

  bool get canSubmit =>
      basicInformationCompleted &&
          categories.primary.isNotEmpty &&
          socialAccounts.isNotEmpty &&
          contentTypes.isNotEmpty &&
          termsCompleted;

  InfluencerRegistration copyWith({
    String? id,

    String? firstName,
    String? lastName,
    String? displayName,

    DateTime? birthDate,
    String? birthPlace,

    String? bio,
    String? skills,

    String? profileImagePath,

    String? email,
    String? phone,
    String? whatsapp,

    InfluencerCategorySelection?
    categories,

    FinancialInformation?
    financialInformation,

    List<InfluencerDocument>?
    documents,

    List<SocialAccount>?
    socialAccounts,

    AudienceProfile? audience,

    List<ContentType>?
    contentTypes,

    NotificationPreferences?
    notificationPreferences,

    bool? confirmInformation,
    bool? acceptedTerms,
    bool? acceptedPrivacy,
    bool? acceptedVerification,
    bool? acceptedContact,

    DateTime? registeredAt,

    InfluencerVerificationStatus?
    verificationStatus,
  }) {
    return InfluencerRegistration(
      id: id ?? this.id,

      firstName:
      firstName ?? this.firstName,
      lastName:
      lastName ?? this.lastName,
      displayName:
      displayName ?? this.displayName,

      birthDate:
      birthDate ?? this.birthDate,
      birthPlace:
      birthPlace ?? this.birthPlace,

      bio: bio ?? this.bio,
      skills: skills ?? this.skills,

      profileImagePath:
      profileImagePath ??
          this.profileImagePath,

      email: email ?? this.email,
      phone: phone ?? this.phone,
      whatsapp:
      whatsapp ?? this.whatsapp,

      categories:
      categories ?? this.categories,

      financialInformation:
      financialInformation ??
          this.financialInformation,

      documents:
      documents ?? this.documents,

      socialAccounts:
      socialAccounts ??
          this.socialAccounts,

      audience:
      audience ?? this.audience,

      contentTypes:
      contentTypes ??
          this.contentTypes,

      notificationPreferences:
      notificationPreferences ??
          this.notificationPreferences,

      confirmInformation:
      confirmInformation ??
          this.confirmInformation,

      acceptedTerms:
      acceptedTerms ??
          this.acceptedTerms,

      acceptedPrivacy:
      acceptedPrivacy ??
          this.acceptedPrivacy,

      acceptedVerification:
      acceptedVerification ??
          this.acceptedVerification,

      acceptedContact:
      acceptedContact ??
          this.acceptedContact,

      registeredAt:
      registeredAt ??
          this.registeredAt,

      verificationStatus:
      verificationStatus ??
          this.verificationStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,

      'firstName': firstName,
      'lastName': lastName,
      'displayName': displayName,

      'birthDate':
      birthDate?.toIso8601String(),

      'birthPlace': birthPlace,

      'bio': bio,
      'skills': skills,

      'profileImagePath':
      profileImagePath,

      'email': email,
      'phone': phone,
      'whatsapp': whatsapp,

      'categories':
      categories.toMap(),

      'financialInformation':
      financialInformation.toMap(),

      'documents': documents
          .map((e) => e.toMap())
          .toList(),

      'socialAccounts': socialAccounts
          .map((e) => e.toMap())
          .toList(),

      'audience': audience.toMap(),

      'contentTypes': contentTypes
          .map((e) => e.name)
          .toList(),

      'notificationPreferences':
      notificationPreferences.toMap(),

      'confirmInformation':
      confirmInformation,

      'acceptedTerms':
      acceptedTerms,

      'acceptedPrivacy':
      acceptedPrivacy,

      'acceptedVerification':
      acceptedVerification,

      'acceptedContact':
      acceptedContact,

      'registeredAt':
      registeredAt?.toIso8601String(),

      'verificationStatus':
      verificationStatus.name,
    };
  }
}