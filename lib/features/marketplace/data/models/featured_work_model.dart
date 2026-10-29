import 'package:x_ten/core/constants/api_keys.dart';
import 'package:x_ten/core/utils/json.dart';
import 'package:x_ten/features/marketplace/domain/entities/featured_work.dart';

class FeaturedWorkModel extends FeaturedWork {
  const FeaturedWorkModel({required super.title, super.description, super.link, super.mediaUrls});

  factory FeaturedWorkModel.fromJson(Json json) => FeaturedWorkModel(
        title: jsonString(json[ApiKeys.title]),
        description: jsonString(json[ApiKeys.description]),
        link: jsonString(json[ApiKeys.link]),
        mediaUrls: [for (final url in json[ApiKeys.mediaUrls] as List? ?? const []) url.toString()],
      );
}
