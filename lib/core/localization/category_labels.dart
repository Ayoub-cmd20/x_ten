import 'package:x_ten/l10n/generated/app_localizations.dart';

extension CategoryLabels on AppLocalizations {
  String category(String id) => switch (id) {
        'acting' => catActing,
        'music' => catMusic,
        'technology' => catTechnology,
        'cooking' => catCooking,
        'sports' => catSports,
        'beauty' => catBeauty,
        'health' => catHealth,
        'publicFigures' => catPublicFigures,
        'education' => catEducation,
        'cars' => catCars,
        'travel' => catTravel,
        'business' => catBusiness,
        'agriculture' => catAgriculture,
        'industry' => catIndustry,
        'comedy' => catComedy,
        'realEstate' => catRealEstate,
        'ecommerce' => catEcommerce,
        _ => id,
      };
}
