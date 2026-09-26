enum InvitationType {
  influencer,
  advertiser,
}

extension InvitationTypeExtension on InvitationType {
  String get arabicName {
    switch (this) {
      case InvitationType.influencer:
        return 'مؤثر';
      case InvitationType.advertiser:
        return 'معلن';
    }
  }
}