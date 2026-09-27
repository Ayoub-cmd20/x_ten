import '../domain/models/social_account.dart';

class SocialPlatformData {
  final SocialPlatform platform;
  final String arabicName;
  final String englishName;

  final bool supportsAutomaticAnalysis;
  final bool supportsFollowers;

  final bool supportsProfileAccount;
  final bool supportsPageAccount;

  const SocialPlatformData({
    required this.platform,
    required this.arabicName,
    required this.englishName,
    this.supportsAutomaticAnalysis = false,
    this.supportsFollowers = true,
    this.supportsProfileAccount = false,
    this.supportsPageAccount = false,
  });
}

const List<SocialPlatformData>
supportedSocialPlatforms = [
  SocialPlatformData(
    platform: SocialPlatform.facebook,
    arabicName: 'فيسبوك',
    englishName: 'Facebook',
    supportsAutomaticAnalysis: true,
    supportsFollowers: true,
    supportsProfileAccount: true,
    supportsPageAccount: true,
  ),

  SocialPlatformData(
    platform: SocialPlatform.instagram,
    arabicName: 'إنستغرام',
    englishName: 'Instagram',
    supportsAutomaticAnalysis: true,
    supportsFollowers: true,
  ),

  SocialPlatformData(
    platform: SocialPlatform.tiktok,
    arabicName: 'تيك توك',
    englishName: 'TikTok',
    supportsAutomaticAnalysis: true,
    supportsFollowers: true,
  ),

  SocialPlatformData(
    platform: SocialPlatform.youtube,
    arabicName: 'يوتيوب',
    englishName: 'YouTube',
    supportsAutomaticAnalysis: true,
    supportsFollowers: true,
  ),

  SocialPlatformData(
    platform: SocialPlatform.snapchat,
    arabicName: 'سناب شات',
    englishName: 'Snapchat',
    supportsAutomaticAnalysis: false,
    supportsFollowers: true,
  ),

  SocialPlatformData(
    platform: SocialPlatform.x,
    arabicName: 'X',
    englishName: 'X',
    supportsAutomaticAnalysis: true,
    supportsFollowers: true,
  ),

  SocialPlatformData(
    platform: SocialPlatform.linkedin,
    arabicName: 'لينكدإن',
    englishName: 'LinkedIn',
    supportsAutomaticAnalysis: false,
    supportsFollowers: true,
  ),

  SocialPlatformData(
    platform: SocialPlatform.website,
    arabicName: 'موقع شخصي',
    englishName: 'Website',
    supportsAutomaticAnalysis: true,
    supportsFollowers: false,
  ),

  SocialPlatformData(
    platform: SocialPlatform.blog,
    arabicName: 'مدونة',
    englishName: 'Blog',
    supportsAutomaticAnalysis: true,
    supportsFollowers: false,
  ),

  SocialPlatformData(
    platform: SocialPlatform.other,
    arabicName: 'منصة أخرى',
    englishName: 'Other',
    supportsAutomaticAnalysis: false,
    supportsFollowers: false,
  ),
];

SocialPlatformData? findSocialPlatformData(
    SocialPlatform platform,
    ) {
  for (final item
  in supportedSocialPlatforms) {
    if (item.platform == platform) {
      return item;
    }
  }

  return null;
}