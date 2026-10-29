import 'package:equatable/equatable.dart';
import 'package:x_ten/features/marketplace/domain/entities/featured_work.dart';

class MarketInfluencer extends Equatable {
  const MarketInfluencer({
    required this.id,
    required this.name,
    this.userId = 0,
    this.category = '',
    this.imageUrl,
    this.joinDate,
    this.rating,
    this.city = '',
    this.bio = '',
    this.isAvailable = true,
    this.profileViews = 0,
    this.interestedAdvertisers = 0,
    this.topPlatform,
    this.followers = 0,
    this.featuredWorks = const [],
  });

  final int id;
  final int userId;
  final String name;
  final String category;
  final String? imageUrl;
  final DateTime? joinDate;
  final double? rating;
  final String city;
  final String bio;
  final bool isAvailable;
  final int profileViews;
  final int interestedAdvertisers;
  final String? topPlatform;
  final int followers;
  final List<FeaturedWork> featuredWorks;

  Map<String, int> get followersByPlatform => {?topPlatform: followers};

  int get totalFollowers => followers;

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        category,
        imageUrl,
        joinDate,
        rating,
        city,
        bio,
        isAvailable,
        profileViews,
        interestedAdvertisers,
        topPlatform,
        followers,
        featuredWorks,
      ];
}
