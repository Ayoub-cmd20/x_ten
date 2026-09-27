enum ContentType {
  photos,
  videos,
  text,
  reels,
  stories,
  live,
  podcasts,
  reviews,
  tutorials,
}

extension ContentTypeExtension
on ContentType {
  String get arabicName {
    switch (this) {
      case ContentType.photos:
        return 'صور';

      case ContentType.videos:
        return 'فيديوهات';

      case ContentType.text:
        return 'محتوى نصي';

      case ContentType.reels:
        return 'Reels';

      case ContentType.stories:
        return 'Stories';

      case ContentType.live:
        return 'بث مباشر';

      case ContentType.podcasts:
        return 'Podcasts';

      case ContentType.reviews:
        return 'مراجعات';

      case ContentType.tutorials:
        return 'شروحات';
    }
  }
}