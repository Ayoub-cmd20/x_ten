class Influencer {
  final String id;
  final String name;
  final String category;
  final String categoryId;
  final String imageUrl;

  final int facebookFollowers;
  final int instagramFollowers;
  final int tiktokFollowers;
  final int youtubeFollowers;

  final DateTime joinDate;
  final double rating;

  final String city;
  final String bio;

  final bool isAvailable;

  // Ambassador details
  final bool isAmbassador;
  final String? ambassadorCategory;
  final int? ambassadorYear;

  // Analytics & portfolio
  final int profileViews;
  final int interestedAdvertisers;
  final List<String> featuredWorks;

  const Influencer({
    required this.id,
    required this.name,
    required this.category,
    required this.categoryId,
    required this.imageUrl,
    required this.facebookFollowers,
    required this.instagramFollowers,
    required this.tiktokFollowers,
    required this.youtubeFollowers,
    required this.joinDate,
    required this.rating,
    required this.city,
    required this.bio,
    required this.isAvailable,
    this.isAmbassador = false,
    this.ambassadorCategory,
    this.ambassadorYear,
    this.profileViews = 0,
    this.interestedAdvertisers = 0,
    this.featuredWorks = const [],
  });
  int get totalFollowers =>
      facebookFollowers +
          instagramFollowers +
          tiktokFollowers +
          youtubeFollowers;
}