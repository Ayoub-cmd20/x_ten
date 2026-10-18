import 'package:x_ten/core/constants/api_keys.dart';
import 'package:x_ten/features/marketplace/domain/marketplace_entities.dart';

typedef Json = Map<String, dynamic>;

String _string(Object? value) => value as String? ?? '';

int _int(Object? value) => switch (value) {
      final int number => number,
      final String text => int.tryParse(text) ?? 0,
      _ => 0,
    };

double? _double(Object? value) => switch (value) {
      final num number => number.toDouble(),
      final String text => double.tryParse(text),
      _ => null,
    };

DateTime? _date(Object? value) => value is String ? DateTime.tryParse(value) : null;

class FeaturedWorkModel extends FeaturedWork {
  const FeaturedWorkModel({required super.title, super.description, super.link, super.mediaUrls});

  factory FeaturedWorkModel.fromJson(Json json) => FeaturedWorkModel(
        title: _string(json[ApiKeys.title]),
        description: _string(json[ApiKeys.description]),
        link: _string(json[ApiKeys.link]),
        mediaUrls: [for (final url in json[ApiKeys.mediaUrls] as List? ?? const []) url.toString()],
      );
}

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
        id: _int(json[ApiKeys.id]),
        userId: _int(json[ApiKeys.userId]),
        name: _string(json[ApiKeys.name]),
        category: _string(json[ApiKeys.category]),
        imageUrl: json[ApiKeys.imageUrl] as String?,
        joinDate: _date(json[ApiKeys.joinDate]),
        rating: _double(json[ApiKeys.rating]),
        city: _string(json[ApiKeys.city]),
        bio: _string(json[ApiKeys.bio]),
        isAvailable: json[ApiKeys.isAvailable] as bool? ?? true,
        profileViews: _int(json[ApiKeys.profileViews]),
        interestedAdvertisers: _int(json[ApiKeys.interestedAdvertisers]),
        topPlatform: json[ApiKeys.topPlatform] as String?,
        followers: _int(json[ApiKeys.followers]),
        featuredWorks: [
          for (final work in json[ApiKeys.featuredWorks] as List? ?? const [])
            FeaturedWorkModel.fromJson(work as Json),
        ],
      );
}
