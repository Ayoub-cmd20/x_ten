import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';
import 'package:x_ten/l10n/generated/app_localizations.dart';

export 'package:x_ten/core/localization/category_labels.dart';

extension RegistrationLabels on AppLocalizations {
  String stepTitle(RegistrationStep step) => switch (step) {
        RegistrationStep.personal => regStepPersonal,
        RegistrationStep.profile => regStepProfile,
        RegistrationStep.contact => regStepContact,
        RegistrationStep.accounts => regStepSocial,
        RegistrationStep.optional => regStepOptional,
        RegistrationStep.financial => regStepFinancial,
        RegistrationStep.security => regStepSecurity,
        RegistrationStep.photo => regStepPhoto,
        RegistrationStep.documents => regStepDocuments,
      };

  String entityTypeLabel(EntityType type) => switch (type) {
        EntityType.natural => regEntityNatural,
        EntityType.legal => regEntityLegal,
      };

  String languageLabel(String code) => switch (code) {
        'arabic' => langArabic,
        'darija' => langDarija,
        'amazigh' => langAmazigh,
        'english' => langEnglish,
        'french' => langFrench,
        'other' => langOther,
        _ => code,
      };

  String levelLabel(LanguageLevel level) => switch (level) {
        LanguageLevel.basic => levelBasic,
        LanguageLevel.good => levelGood,
        LanguageLevel.advanced => levelAdvanced,
      };

  String skillGroupLabel(String group) => switch (group) {
        'core' => skillGroupCore,
        'production' => skillGroupProduction,
        'marketing' => skillGroupMarketing,
        'advanced' => skillGroupAdvanced,
        _ => group,
      };

  String skillLabel(String id) => switch (id) {
        'copywriting' => skillCopywriting,
        'storytelling' => skillStorytelling,
        'onCamera' => skillOnCamera,
        'acting' => skillActing,
        'voiceOver' => skillVoiceOver,
        'productReviews' => skillProductReviews,
        'educational' => skillEducational,
        'motivational' => skillMotivational,
        'comedy' => skillComedy,
        'dailyLife' => skillDailyLife,
        'videoShooting' => skillVideoShooting,
        'photography' => skillPhotography,
        'videoEditing' => skillVideoEditing,
        'photoEditing' => skillPhotoEditing,
        'directing' => skillDirecting,
        'lighting' => skillLighting,
        'audioSetup' => skillAudioSetup,
        'adIntegration' => skillAdIntegration,
        'indirectPromotion' => skillIndirectPromotion,
        'effectiveCta' => skillEffectiveCta,
        'brandIdentity' => skillBrandIdentity,
        'briefCompliance' => skillBriefCompliance,
        'campaignManagement' => skillCampaignManagement,
        'adScripting' => skillAdScripting,
        'performanceAnalysis' => skillPerformanceAnalysis,
        'contentRepurposing' => skillContentRepurposing,
        'multilingual' => skillMultilingual,
        _ => id,
      };

  String adContentTypeLabel(String id) => switch (id) {
        'review' => adctReview,
        'testTry' => adctTestTry,
        'unboxing' => adctUnboxing,
        'tutorial' => adctTutorial,
        'personalRecommendation' => adctRecommendation,
        'directCta' => adctDirectCta,
        'storytelling' => adctStorytelling,
        'productPlacement' => adctProductPlacement,
        _ => id,
      };

  String regionLabel(String id) => switch (id) {
        'north' => regionNorth,
        'northEast' => regionNorthEast,
        'northWest' => regionNorthWest,
        'center' => regionCenter,
        'centerEast' => regionCenterEast,
        'centerWest' => regionCenterWest,
        'south' => regionSouth,
        'southEast' => regionSouthEast,
        'southWest' => regionSouthWest,
        _ => id,
      };

  String audienceGenderLabel(String id) => switch (id) {
        'male' => audMale,
        'female' => audFemale,
        'unspecified' => audUnspecified,
        _ => id,
      };

  String ageLabel(String id) => id == 'under18' ? audAgeUnder18 : id;

  String audienceLanguageLabel(String id) => switch (id) {
        'arabic' => audLangArabic,
        'amazigh' => audLangAmazigh,
        'english' => audLangEnglish,
        'french' => audLangFrench,
        'mixed' => audLangMixed,
        _ => id,
      };

  String audienceContentLabel(String id) => switch (id) {
        'video' => audVideo,
        'photo' => audPhoto,
        'stories' => 'Stories',
        'live' => 'Live',
        _ => id,
      };

  String dayLabel(String id) => switch (id) {
        'sat' => daySat,
        'sun' => daySun,
        'mon' => dayMon,
        'tue' => dayTue,
        'wed' => dayWed,
        'thu' => dayThu,
        'fri' => dayFri,
        _ => id,
      };

  String purchasingLabel(String id) => switch (id) {
        'low' => audLow,
        'medium' => audMedium,
        'high' => audHigh,
        _ => id,
      };

  String platformId(String id) => platform(SocialPlatform.values.firstWhere(
        (p) => p.name == id,
        orElse: () => SocialPlatform.other,
      ));

  String platform(SocialPlatform platform) => switch (platform) {
        SocialPlatform.facebook => 'Facebook',
        SocialPlatform.instagram => 'Instagram',
        SocialPlatform.tiktok => 'TikTok',
        SocialPlatform.youtube => 'YouTube',
        SocialPlatform.snapchat => 'Snapchat',
        SocialPlatform.x => 'X',
        SocialPlatform.linkedin => 'LinkedIn',
        SocialPlatform.telegram => 'Telegram',
        SocialPlatform.website => platformWebsite,
        SocialPlatform.blog => platformBlog,
        SocialPlatform.other => platformOther,
      };

  String financialKindLabel(FinancialKind kind) => switch (kind) {
        FinancialKind.ccp => finCcp,
        FinancialKind.bank => finBank,
        FinancialKind.other => finOther,
      };

  String documentLabel(DocumentType type) => switch (type) {
        DocumentType.identityFront => docIdentityFront,
        DocumentType.identityBack => docIdentityBack,
        DocumentType.passport => docPassport,
        DocumentType.ccpCheque => docCcpCheque,
        DocumentType.bankRib => docBankRib,
        DocumentType.financialProof => docFinancialProof,
        DocumentType.other => docOther,
      };

  String documentList(Iterable<DocumentType> types) => types.map(documentLabel).join(listSeparator);
}
