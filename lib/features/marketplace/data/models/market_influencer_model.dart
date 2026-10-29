import 'package:x_ten/core/constants/api_keys.dart';
import 'package:x_ten/core/utils/json.dart';
import 'package:x_ten/features/marketplace/data/models/featured_work_model.dart';
import 'package:x_ten/features/marketplace/domain/entities/market_influencer.dart';

class MarketInfluencerModel extends MarketInfluencer {
  const MarketInfluencerModel({
    required super.id,
    required super.name,
    super.userId,
    super.category,
    super.imageUrl,
    super.joinDate,
    super.rating,
    super.city,
    super.bio,
    super.isAvailable,
    super.profileViews,
    super.interestedAdvertisers,
    super.topPlatform,
    super.followers,
    super.featuredWorks,
  });

  factory MarketInfluencerModel.fromJson(Json json) => MarketInfluencerModel(
        id: jsonInt(json[ApiKeys.id]),
        userId: jsonInt(json[ApiKeys.userId]),
        name: jsonString(json[ApiKeys.name]),
        category: jsonString(json[ApiKeys.category]),
        imageUrl: json[ApiKeys.imageUrl] as String?,
        joinDate: jsonDate(json[ApiKeys.joinDate]),
        rating: jsonDouble(json[ApiKeys.rating]),
        city: jsonString(json[ApiKeys.city]),
        bio: jsonString(json[ApiKeys.bio]),
        isAvailable: json[ApiKeys.isAvailable] as bool? ?? true,
        profileViews: jsonInt(json[ApiKeys.profileViews]),
        interestedAdvertisers: jsonInt(json[ApiKeys.interestedAdvertisers]),
        topPlatform: json[ApiKeys.topPlatform] as String?,
        followers: jsonInt(json[ApiKeys.followers]),
        featuredWorks: [
          for (final work in json[ApiKeys.featuredWorks] as List? ?? const [])
            FeaturedWorkModel.fromJson(work as Json),
        ],
      );
}
