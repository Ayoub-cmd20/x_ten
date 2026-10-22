import 'package:x_ten/core/constants/api_keys.dart';
import 'package:x_ten/core/enums/verification_status.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';

typedef Json = Map<String, dynamic>;

String _string(Object? value) => value as String? ?? '';

List<String> _strings(Object? value) => [for (final item in value as List? ?? const []) '$item'];

DateTime? _date(Object? value) => value is String ? DateTime.tryParse(value) : null;

String _formatDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

num _compact(double value) => value == value.roundToDouble() ? value.toInt() : value;


List<Json> _sharesToJson(Map<String, double> shares) => [
      for (final entry in shares.entries) {ApiKeys.key: entry.key, ApiKeys.percent: _compact(entry.value)},
    ];

Map<String, double> _sharesFromJson(Object? value) => {
      for (final item in (value as List? ?? const []).whereType<Json>())
        '${item[ApiKeys.key]}': (item[ApiKeys.percent] as num? ?? 0).toDouble(),
    };

abstract final class RegistrationJson {
  static Json section(RegistrationSection section) => switch (section) {
        final PersonalInfo personal => {
            ApiKeys.firstName: personal.firstName,
            ApiKeys.lastName: personal.lastName,
            ApiKeys.birthDate: switch (personal.birthDate) {
              final date? => _formatDate(date),
              null => null,
            },
            ApiKeys.birthPlace: personal.birthPlace,
            ApiKeys.idNumber: personal.idNumber,
            ApiKeys.entityType: personal.entityType?.name ?? '',
          },
        final ProfileInfo profile => {
            ApiKeys.displayName: profile.displayName,
            ApiKeys.primaryCategories: profile.primaryCategories,
            ApiKeys.secondaryCategories: profile.secondaryCategories,
            ApiKeys.bio: profile.bio,
            ApiKeys.contentLanguages: [
              for (final language in profile.contentLanguages)
                {
                  ApiKeys.code: language.code,
                  ApiKeys.percent: _compact(language.percent),
                  if (language.name.isNotEmpty) ApiKeys.name: language.name,
                },
            ],
            ApiKeys.addressLanguages: profile.addressLanguages,
          },
        final ContactInfo contact => {
            ApiKeys.phone: contact.phone,
            ApiKeys.whatsapp: contact.whatsapp,
            ApiKeys.email: contact.email,
            ApiKeys.backupPhone: contact.backupPhone,
            ApiKeys.deliveryAddress: contact.deliveryAddress,
          },
        final OptionalInfo optional => {
            ApiKeys.audience: audience(optional.audience),
            ApiKeys.contentTypes: optional.contentTypes,
          },
        final ConsentInfo consents => {
            ApiKeys.acceptedTerms: consents.acceptedTerms,
            ApiKeys.acceptedPrivacy: consents.acceptedPrivacy,
          },
      };

  static Json audience(Audience audience) => {
        ApiKeys.countries: [
          for (final c in audience.countries) {ApiKeys.country: c.country, ApiKeys.percent: _compact(c.percent)},
        ],
        ApiKeys.regions: _sharesToJson(audience.regions),
        ApiKeys.regionsUnspecified: audience.regionsUnspecified,
        ApiKeys.gender: _sharesToJson(audience.gender),
        ApiKeys.ages: _sharesToJson(audience.ages),
        ApiKeys.languages: _sharesToJson(audience.languages),
        ApiKeys.topPlatforms: audience.topPlatforms,
        ApiKeys.activity: {
          ApiKeys.days: audience.activityDays,
          ApiKeys.fromHour: audience.fromHour,
          ApiKeys.toHour: audience.toHour,
        },
        ApiKeys.contentEngagement: audience.contentEngagement,
      };

  static Audience audienceFrom(Object? value) {
    if (value is! Json) return const Audience();
    final activity = value[ApiKeys.activity] as Json? ?? const {};
    return Audience(
      countries: [
        for (final item in (value[ApiKeys.countries] as List? ?? const []).whereType<Json>())
          CountryShare(
            country: _string(item[ApiKeys.country]),
            percent: (item[ApiKeys.percent] as num? ?? 0).toDouble(),
          ),
      ],
      regions: _sharesFromJson(value[ApiKeys.regions]),
      regionsUnspecified: value[ApiKeys.regionsUnspecified] as bool? ?? false,
      gender: _sharesFromJson(value[ApiKeys.gender]),
      ages: _sharesFromJson(value[ApiKeys.ages]),
      languages: _sharesFromJson(value[ApiKeys.languages]),
      topPlatforms: _strings(value[ApiKeys.topPlatforms]),
      activityDays: _strings(activity[ApiKeys.days]),
      fromHour: _string(activity[ApiKeys.fromHour]),
      toHour: _string(activity[ApiKeys.toHour]),
      contentEngagement: [
        for (final item in value[ApiKeys.contentEngagement] as List? ?? const [])
          if (item is String) item,
      ],
    );
  }

  static Json portfolioItem(PortfolioItem item) => {
        ApiKeys.title: item.title,
        ApiKeys.description: item.description,
        if (item.link.isNotEmpty) ApiKeys.link: item.link,
      };

  static FinancialAccount readAccount(Json json) => FinancialAccount(
        institutionName: _string(json[ApiKeys.institutionName]),
        accountNumber: _string(json[ApiKeys.accountNumber]),
      );

  static Json financialAccount(FinancialAccount account) => {
        ApiKeys.institutionName: account.institutionName,
        ApiKeys.accountNumber: account.accountNumber,
        ApiKeys.accountKey: account.accountKey,
      };
}

class RegistrationModel extends Registration {
  const RegistrationModel({
    required super.id,
    required super.attemptNumber,
    required super.isCurrent,
    required super.personal,
    required super.profile,
    required super.contact,
    required super.optional,
    required super.status,
    super.consents,
    super.profileImageUrl,
    super.submittedAt,
    super.updatedAt,
  });

  factory RegistrationModel.fromJson(Json json) => RegistrationModel(
        id: json[ApiKeys.id] as int,
        attemptNumber: json[ApiKeys.attemptNumber] as int? ?? 1,
        isCurrent: json[ApiKeys.isCurrent] as bool? ?? false,
        personal: PersonalInfo(
          firstName: _string(json[ApiKeys.firstName]),
          lastName: _string(json[ApiKeys.lastName]),
          birthDate: _date(json[ApiKeys.birthDate]),
          birthPlace: _string(json[ApiKeys.birthPlace]),
          idNumber: _string(json[ApiKeys.idNumber]),
          entityType: maybeEnum(EntityType.values, json[ApiKeys.entityType] as String?),
        ),
        profile: ProfileInfo(
          displayName: _string(json[ApiKeys.displayName]),
          primaryCategories: _strings(json[ApiKeys.primaryCategories]),
          secondaryCategories: _strings(json[ApiKeys.secondaryCategories]),
          bio: _string(json[ApiKeys.bio]),
          contentLanguages: [
            for (final item in (json[ApiKeys.contentLanguages] as List? ?? const []).whereType<Json>())
              ContentLanguage(
                code: _string(item[ApiKeys.code]),
                percent: (item[ApiKeys.percent] as num? ?? 0).toDouble(),
                name: _string(item[ApiKeys.name]),
              ),
          ],
          addressLanguages: _strings(json[ApiKeys.addressLanguages]),
        ),
        contact: ContactInfo(
          phone: _string(json[ApiKeys.phone]),
          whatsapp: _string(json[ApiKeys.whatsapp]),
          email: _string(json[ApiKeys.email]),
          backupPhone: _string(json[ApiKeys.backupPhone]),
          deliveryAddress: _string(json[ApiKeys.deliveryAddress]),
        ),
        optional: OptionalInfo(
          audience: RegistrationJson.audienceFrom(json[ApiKeys.audience]),
          contentTypes: _strings(json[ApiKeys.contentTypes]),
        ),
        consents: ConsentInfo(
          acceptedTerms: json[ApiKeys.acceptedTerms] as bool? ?? false,
          acceptedPrivacy: json[ApiKeys.acceptedPrivacy] as bool? ?? false,
        ),
        profileImageUrl: json[ApiKeys.profileImageUrl] as String?,
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
    super.accountName,
    super.username,
    super.facebookAccountType,
    super.followers,
    super.avatarUrl,
    super.source,
    super.lastSyncedAt,
    super.verified,
    super.hasScreenshot,
  });

  factory SocialAccountModel.fromJson(Json json) => SocialAccountModel(
        id: json[ApiKeys.id] as int,
        platform: enumFromApi(SocialPlatform.values, json[ApiKeys.platform] as String?, SocialPlatform.other),
        facebookAccountType: maybeEnum(FacebookAccountType.values, json[ApiKeys.facebookAccountType] as String?),
        url: _string(json[ApiKeys.url]),
        accountName: _string(json[ApiKeys.accountName]),
        username: _string(json[ApiKeys.username]),
        followers: (json[ApiKeys.followers] as num? ?? 0).toInt(),
        avatarUrl: _string(json[ApiKeys.avatarUrl]),
        source: enumFromApi(SocialSource.values, json[ApiKeys.source] as String?, SocialSource.manual),
        lastSyncedAt: _date(json[ApiKeys.lastSyncedAt]),
        verified: json[ApiKeys.verified] as bool? ?? false,
        hasScreenshot: json[ApiKeys.hasScreenshot] as bool? ?? false,
      );
}

class PortfolioItemModel extends PortfolioItem {
  const PortfolioItemModel({
    required super.id,
    required super.title,
    super.description,
    super.link,
    super.fileName,
    super.fileUrl,
  });

  factory PortfolioItemModel.fromJson(Json json) => PortfolioItemModel(
        id: json[ApiKeys.id] as int,
        title: _string(json[ApiKeys.title]),
        description: _string(json[ApiKeys.description]),
        link: _string(json[ApiKeys.link]),
        fileName: _string(json[ApiKeys.fileName]),
        fileUrl: json[ApiKeys.fileUrl] as String?,
      );
}

class FinancialAccountModel extends FinancialAccount {
  const FinancialAccountModel({
    required super.id,
    required super.accountNumber,
    super.kind,
    super.institutionName,
    super.accountKey,
    super.keyValid,
  });

  factory FinancialAccountModel.fromJson(Json json) => FinancialAccountModel(
        id: json[ApiKeys.id] as int,
        kind: enumFromApi(FinancialKind.values, json[ApiKeys.kind] as String?, FinancialKind.other),
        institutionName: _string(json[ApiKeys.institutionName]),
        accountNumber: _string(json[ApiKeys.accountNumber]),
        accountKey: _string(json[ApiKeys.accountKey]),
        keyValid: json[ApiKeys.keyValid] as bool?,
      );
}

class RegistrationDocumentModel extends RegistrationDocument {
  const RegistrationDocumentModel({
    required super.id,
    required super.type,
    required super.fileName,
    required super.verified,
    required super.downloadUrl,
    super.financialAccountId,
    super.check,
    super.scanned,
    super.createdAt,
  });

  factory RegistrationDocumentModel.fromJson(Json json) => RegistrationDocumentModel(
        id: json[ApiKeys.id] as int,
        type: enumFromApi(DocumentType.values, json[ApiKeys.type] as String?, DocumentType.other),
        financialAccountId: json[ApiKeys.financialAccountId] as int?,
        fileName: _string(json[ApiKeys.fileName]),
        verified: json[ApiKeys.verified] as bool? ?? false,
        check: enumFromApi(DocumentCheck.values, json[ApiKeys.checkStatus] as String?, DocumentCheck.notChecked),
        scanned: ScannedFieldsModel.fromJson(json[ApiKeys.extracted]),
        downloadUrl: _string(json[ApiKeys.downloadUrl]),
        createdAt: _date(json[ApiKeys.createdAt]),
      );
}

class ScannedFieldsModel extends ScannedFields {
  const ScannedFieldsModel({
    super.firstName,
    super.lastName,
    super.idNumber,
    super.birthDate,
    super.birthPlace,
  });

  factory ScannedFieldsModel.fromJson(Object? value) {
    if (value is! Json) return const ScannedFieldsModel();
    String text(Object? v) => v == null ? '' : '$v';
    return ScannedFieldsModel(
      firstName: text(value[ApiKeys.firstName]),
      lastName: text(value[ApiKeys.lastName]),
      idNumber: text(value[ApiKeys.idNumber]),
      birthDate: _date(value[ApiKeys.birthDate]),
      birthPlace: text(value[ApiKeys.birthPlace]),
    );
  }
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
