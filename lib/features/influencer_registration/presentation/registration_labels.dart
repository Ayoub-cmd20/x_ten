import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';
import 'package:x_ten/l10n/generated/app_localizations.dart';

extension RegistrationLabels on AppLocalizations {
  String stepTitle(RegistrationStep step) => switch (step) {
        RegistrationStep.basicInfo => stepBasicInfo,
        RegistrationStep.audience => stepAudience,
        RegistrationStep.accounts => stepAccounts,
        RegistrationStep.photo => stepPhoto,
        RegistrationStep.financial => stepFinancial,
        RegistrationStep.review => stepReview,
      };

  String category(String id) => switch (id) {
        'technology' => catTechnology,
        'gaming' => catGaming,
        'sports' => catSports,
        'football' => catFootball,
        'fitness' => catFitness,
        'health' => catHealth,
        'beauty' => catBeauty,
        'fashion' => catFashion,
        'lifestyle' => catLifestyle,
        'cooking' => catCooking,
        'travel' => catTravel,
        'cars' => catCars,
        'education' => catEducation,
        'business' => catBusiness,
        'finance' => catFinance,
        'marketing' => catMarketing,
        'ecommerce' => catEcommerce,
        'art' => catArt,
        'music' => catMusic,
        'entertainment' => catEntertainment,
        'family' => catFamily,
        'photography' => catPhotography,
        _ => id,
      };

  String contentType(String id) => switch (id) {
        'post' => ctPost,
        'reel' => ctReel,
        'story' => ctStory,
        'video' => ctVideo,
        'live' => ctLive,
        'podcast' => ctPodcast,
        'review' => ctReview,
        'tutorial' => ctTutorial,
        _ => id,
      };

  String platform(SocialPlatform platform) => switch (platform) {
        SocialPlatform.facebook => 'Facebook',
        SocialPlatform.instagram => 'Instagram',
        SocialPlatform.tiktok => 'TikTok',
        SocialPlatform.youtube => 'YouTube',
        SocialPlatform.snapchat => 'Snapchat',
        SocialPlatform.x => 'X',
        SocialPlatform.linkedin => 'LinkedIn',
        SocialPlatform.website => platformWebsite,
        SocialPlatform.blog => platformBlog,
        SocialPlatform.other => platformOther,
      };

  String facebookType(FacebookAccountType type) => switch (type) {
        FacebookAccountType.profile => facebookProfile,
        FacebookAccountType.page => facebookPage,
      };

  String accountTypeLabel(FinancialAccountType type) => switch (type) {
        FinancialAccountType.ccp => accountTypeCcp,
        FinancialAccountType.bank => accountTypeBank,
        FinancialAccountType.both => accountTypeBoth,
      };

  String documentLabel(DocumentType type) => switch (type) {
        DocumentType.identityFront => docIdentityFront,
        DocumentType.identityBack => docIdentityBack,
        DocumentType.ccpCheque => docCcpCheque,
        DocumentType.bankRib => docBankRib,
        DocumentType.other => docOther,
      };

  String documentList(Iterable<DocumentType> types) => types.map(documentLabel).join(listSeparator);
}
