enum SocialPlatform {
  facebook,
  instagram,
  tiktok,
  youtube,
  snapchat,
  x,
  linkedin,
  website,
  blog,
  other,
}

extension SocialPlatformExtension
on SocialPlatform {
  String get displayName {
    switch (this) {
      case SocialPlatform.facebook:
        return 'Facebook';

      case SocialPlatform.instagram:
        return 'Instagram';

      case SocialPlatform.tiktok:
        return 'TikTok';

      case SocialPlatform.youtube:
        return 'YouTube';

      case SocialPlatform.snapchat:
        return 'Snapchat';

      case SocialPlatform.x:
        return 'X';

      case SocialPlatform.linkedin:
        return 'LinkedIn';

      case SocialPlatform.website:
        return 'Website';

      case SocialPlatform.blog:
        return 'Blog';

      case SocialPlatform.other:
        return 'Other';
    }
  }
}

enum FacebookAccountType {
  profile,
  page,
}

extension FacebookAccountTypeExtension
on FacebookAccountType {
  String get arabicName {
    switch (this) {
      case FacebookAccountType.profile:
        return 'ملف شخصي';

      case FacebookAccountType.page:
        return 'صفحة Facebook';
    }
  }
}

class SocialAccount {
  final String id;

  final SocialPlatform platform;

  final FacebookAccountType?
  facebookAccountType;

  final String url;

  final String accountName;

  final String? username;

  final String description;

  final int followers;

  final String? avatarUrl;

  final bool verified;

  const SocialAccount({
    required this.id,
    required this.platform,
    required this.url,
    required this.accountName,
    required this.description,
    required this.followers,
    this.username,
    this.avatarUrl,
    this.facebookAccountType,
    this.verified = false,
  });

  SocialAccount copyWith({
    String? id,
    SocialPlatform? platform,
    FacebookAccountType?
    facebookAccountType,
    String? url,
    String? accountName,
    String? username,
    String? description,
    int? followers,
    String? avatarUrl,
    bool? verified,
  }) {
    return SocialAccount(
      id: id ?? this.id,
      platform:
      platform ?? this.platform,
      facebookAccountType:
      facebookAccountType ??
          this.facebookAccountType,
      url: url ?? this.url,
      accountName:
      accountName ??
          this.accountName,
      username:
      username ?? this.username,
      description:
      description ??
          this.description,
      followers:
      followers ?? this.followers,
      avatarUrl:
      avatarUrl ?? this.avatarUrl,
      verified:
      verified ?? this.verified,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'platform': platform.name,
      'facebookAccountType':
      facebookAccountType?.name,
      'url': url,
      'accountName': accountName,
      'username': username,
      'description': description,
      'followers': followers,
      'avatarUrl': avatarUrl,
      'verified': verified,
    };
  }

  factory SocialAccount.fromMap(
      Map<String, dynamic> map,
      ) {
    FacebookAccountType? fbType;

    if (map['facebookAccountType'] !=
        null) {
      fbType =
          FacebookAccountType.values
              .firstWhere(
                (e) =>
            e.name ==
                map['facebookAccountType'],
            orElse: () =>
            FacebookAccountType.page,
          );
    }

    return SocialAccount(
      id: map['id'] ?? '',
      platform:
      SocialPlatform.values.firstWhere(
            (e) =>
        e.name == map['platform'],
        orElse: () =>
        SocialPlatform.other,
      ),
      facebookAccountType: fbType,
      url: map['url'] ?? '',
      accountName:
      map['accountName'] ?? '',
      username: map['username'],
      description:
      map['description'] ?? '',
      followers:
      map['followers'] ?? 0,
      avatarUrl: map['avatarUrl'],
      verified:
      map['verified'] ?? false,
    );
  }
}