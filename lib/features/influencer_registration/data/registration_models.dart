import 'package:x_ten/core/constants/api_keys.dart';
import 'package:x_ten/core/enums/verification_status.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';

typedef Json = Map<String, dynamic>;

String _string(Object? value) => value as String? ?? '';

List<String> _strings(Object? value) => [for (final item in value as List? ?? const []) '$item'];

Map<String, double> _percentages(Object? value) => {
      for (final entry in (value as Map? ?? const {}).entries) '${entry.key}': (entry.value as num).toDouble(),
    };

DateTime? _date(Object? value) => value is String ? DateTime.tryParse(value) : null;

String _formatDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

num _compact(double value) => value == value.roundToDouble() ? value.toInt() : value;

abstract final class RegistrationJson {
  static Json basic(BasicInfo basic) => {
        ApiKeys.firstName: basic.firstName,
        ApiKeys.lastName: basic.lastName,
        ApiKeys.displayName: basic.displayName,
        ApiKeys.birthDate: switch (basic.birthDate) {
          final date? => _formatDate(date),
          null => null,
        },
        ApiKeys.birthPlace: basic.birthPlace,
        ApiKeys.bio: basic.bio,
        ApiKeys.skills: basic.skills,
        if (basic.whatsapp.isNotEmpty) ApiKeys.whatsapp: basic.whatsapp,
      };

  static Json audience(Audience audience) => {
        ApiKeys.ageDistribution: {
          for (final entry in audience.ageDistribution.entries)
            if (entry.value > 0) entry.key: _compact(entry.value),
        },
        ApiKeys.malePercentage: _compact(audience.malePercentage),
        ApiKeys.femalePercentage: _compact(audience.femalePercentage),
        ApiKeys.locations: {
          for (final entry in audience.locations.entries) entry.key: _compact(entry.value),
        },
        ApiKeys.interests: audience.interests,
      };

  static Json profile(ProfileInfo profile) => {
        ApiKeys.primaryCategories: profile.primaryCategories,
        ApiKeys.secondaryCategories: profile.secondaryCategories,
        ApiKeys.contentTypes: profile.contentTypes,
        ApiKeys.audience: audience(profile.audience),
      };

  static Json financial(FinancialInfo financial) => {
        ApiKeys.financialInformation: {
          ApiKeys.accountType: financial.accountType.name,
          ApiKeys.ccpAccount: financial.ccpAccount,
          ApiKeys.ccpKey: financial.ccpKey,
          ApiKeys.bankName: financial.bankName,
          ApiKeys.bankAccount: financial.bankAccount,
          ApiKeys.rib: financial.rib,
        },
      };

  static Json consents(Consents consents, NotificationPreferences notifications) => {
        ApiKeys.confirmInformation: consents.confirmInformation,
        ApiKeys.acceptedTerms: consents.acceptedTerms,
        ApiKeys.acceptedPrivacy: consents.acceptedPrivacy,
        ApiKeys.acceptedVerification: consents.acceptedVerification,
        ApiKeys.acceptedContact: consents.acceptedContact,
        ApiKeys.notificationPreferences: {
          ApiKeys.inApp: notifications.inApp,
          ApiKeys.sms: notifications.sms,
          ApiKeys.phoneCall: notifications.phoneCall,
          ApiKeys.email: notifications.email,
          ApiKeys.whatsapp: notifications.whatsapp,
        },
      };

  static Json socialAccount(SocialAccount account) => {
        ApiKeys.platform: account.platform.name,
        if (account.facebookAccountType case final type?) ApiKeys.facebookAccountType: type.name,
        ApiKeys.url: account.url,
        ApiKeys.accountName: account.accountName,
        ApiKeys.username: account.username,
        ApiKeys.description: account.description,
        ApiKeys.followers: account.followers,
      };

  static Json portfolioItem(PortfolioItem item) => {
        ApiKeys.title: item.title,
        ApiKeys.description: item.description,
        ApiKeys.link: item.link,
        ApiKeys.mediaUrls: item.mediaUrls,
      };
}

class AudienceModel extends Audience {
  const AudienceModel({
    required super.ageDistribution,
    required super.malePercentage,
    required super.femalePercentage,
    required super.locations,
    required super.interests,
  });

  static AudienceModel? maybeFromJson(Object? json) {
    if (json is! Json || json.isEmpty) return null;
    return AudienceModel(
      ageDistribution: _percentages(json[ApiKeys.ageDistribution]),
      malePercentage: (json[ApiKeys.malePercentage] as num? ?? 0).toDouble(),
      femalePercentage: (json[ApiKeys.femalePercentage] as num? ?? 0).toDouble(),
      locations: _percentages(json[ApiKeys.locations]),
      interests: _strings(json[ApiKeys.interests]),
    );
  }
}

class FinancialInfoModel extends FinancialInfo {
  const FinancialInfoModel({
    required super.accountType,
    super.ccpAccount,
    super.ccpKey,
    super.bankName,
    super.bankAccount,
    super.rib,
  });

  static FinancialInfoModel? maybeFromJson(Object? json) {
    if (json is! Json) return null;
    return FinancialInfoModel(
      accountType: enumFromApi(FinancialAccountType.values, json[ApiKeys.accountType] as String?, FinancialAccountType.ccp),
      ccpAccount: _string(json[ApiKeys.ccpAccount]),
      ccpKey: _string(json[ApiKeys.ccpKey]),
      bankName: _string(json[ApiKeys.bankName]),
      bankAccount: _string(json[ApiKeys.bankAccount]),
      rib: _string(json[ApiKeys.rib]),
    );
  }
}

class RegistrationModel extends Registration {
  const RegistrationModel({
    required super.id,
    required super.attemptNumber,
    required super.isCurrent,
    required super.basic,
    required super.email,
    required super.phone,
    required super.primaryCategories,
    required super.secondaryCategories,
    required super.contentTypes,
    required super.consents,
    required super.status,
    super.profileImageUrl,
    super.audience,
    super.financial,
    super.submittedAt,
    super.updatedAt,
  });

  factory RegistrationModel.fromJson(Json json) => RegistrationModel(
        id: json[ApiKeys.id] as int,
        attemptNumber: json[ApiKeys.attemptNumber] as int? ?? 1,
        isCurrent: json[ApiKeys.isCurrent] as bool? ?? false,
        basic: BasicInfo(
          firstName: _string(json[ApiKeys.firstName]),
          lastName: _string(json[ApiKeys.lastName]),
          displayName: _string(json[ApiKeys.displayName]),
          birthDate: _date(json[ApiKeys.birthDate]),
          birthPlace: _string(json[ApiKeys.birthPlace]),
          bio: _string(json[ApiKeys.bio]),
          skills: _string(json[ApiKeys.skills]),
          whatsapp: _string(json[ApiKeys.whatsapp]),
        ),
        email: _string(json[ApiKeys.email]),
        phone: _string(json[ApiKeys.phone]),
        profileImageUrl: json[ApiKeys.profileImageUrl] as String?,
        primaryCategories: _strings(json[ApiKeys.primaryCategories]),
        secondaryCategories: _strings(json[ApiKeys.secondaryCategories]),
        contentTypes: _strings(json[ApiKeys.contentTypes]),
        audience: AudienceModel.maybeFromJson(json[ApiKeys.audience]),
        financial: FinancialInfoModel.maybeFromJson(json[ApiKeys.financialInformation]),
        consents: Consents(
          confirmInformation: json[ApiKeys.confirmInformation] as bool? ?? false,
          acceptedTerms: json[ApiKeys.acceptedTerms] as bool? ?? false,
          acceptedPrivacy: json[ApiKeys.acceptedPrivacy] as bool? ?? false,
          acceptedVerification: json[ApiKeys.acceptedVerification] as bool? ?? false,
          acceptedContact: json[ApiKeys.acceptedContact] as bool? ?? false,
        ),
        status: VerificationStatus.fromApi(json[ApiKeys.verificationStatus] as String?),
        submittedAt: _date(json[ApiKeys.submittedAt]),
        updatedAt: _date(json[ApiKeys.updatedAt]),
      );
}

class SocialAccountModel extends SocialAccount {
  const SocialAccountModel({
    required super.id,
    required super.platform,
    required super.url,
    required super.accountName,
    required super.username,
    super.facebookAccountType,
    super.description,
    super.followers,
    super.avatarUrl,
    super.verified,
  });

  factory SocialAccountModel.fromJson(Json json) => SocialAccountModel(
        id: json[ApiKeys.id] as int,
        platform: enumFromApi(SocialPlatform.values, json[ApiKeys.platform] as String?, SocialPlatform.other),
        facebookAccountType: switch (json[ApiKeys.facebookAccountType]) {
          final String type when type.isNotEmpty => enumFromApi(FacebookAccountType.values, type, FacebookAccountType.profile),
          _ => null,
        },
        url: _string(json[ApiKeys.url]),
        accountName: _string(json[ApiKeys.accountName]),
        username: _string(json[ApiKeys.username]),
        description: _string(json[ApiKeys.description]),
        followers: (json[ApiKeys.followers] as num? ?? 0).toInt(),
        avatarUrl: _string(json[ApiKeys.avatarUrl]),
        verified: json[ApiKeys.verified] as bool? ?? false,
      );
}

class PortfolioItemModel extends PortfolioItem {
  const PortfolioItemModel({
    required super.id,
    required super.title,
    required super.description,
    required super.link,
    super.mediaUrls,
  });

  factory PortfolioItemModel.fromJson(Json json) => PortfolioItemModel(
        id: json[ApiKeys.id] as int,
        title: _string(json[ApiKeys.title]),
        description: _string(json[ApiKeys.description]),
        link: _string(json[ApiKeys.link]),
        mediaUrls: _strings(json[ApiKeys.mediaUrls]),
      );
}

class RegistrationDocumentModel extends RegistrationDocument {
  const RegistrationDocumentModel({
    required super.id,
    required super.type,
    required super.fileName,
    required super.verified,
    required super.downloadUrl,
    super.createdAt,
  });

  factory RegistrationDocumentModel.fromJson(Json json) => RegistrationDocumentModel(
        id: json[ApiKeys.id] as int,
        type: enumFromApi(DocumentType.values, json[ApiKeys.type] as String?, DocumentType.other),
        fileName: _string(json[ApiKeys.fileName]),
        verified: json[ApiKeys.verified] as bool? ?? false,
        downloadUrl: _string(json[ApiKeys.downloadUrl]),
        createdAt: _date(json[ApiKeys.createdAt]),
      );
}

class VerificationMeetingModel extends VerificationMeeting {
  const VerificationMeetingModel({
    required super.id,
    required super.contextId,
    required super.scheduledAt,
    required super.status,
  });

  factory VerificationMeetingModel.fromJson(Json json) => VerificationMeetingModel(
        id: json[ApiKeys.id] as int,
        contextId: json[ApiKeys.contextId] as int? ?? 0,
        scheduledAt: (_date(json[ApiKeys.scheduledAt]) ?? DateTime.now()).toLocal(),
        status: enumFromApi(MeetingStatus.values, json[ApiKeys.status] as String?, MeetingStatus.unknown),
      );
}
