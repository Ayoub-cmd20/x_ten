import 'package:x_ten/l10n/generated/app_localizations.dart';

extension CategoryLabels on AppLocalizations {
  String category(String id) => switch (id) {
        'technology' => catTechnology,
        'gaming' => catGaming,
        'sports' => catSports,
        'football' => catFootball,
        'fitness' => catFitness,
        'health' => catHealth,
        'beauty' => catBeauty,
        'fashion' => catFashion,
        'lifestyle' => catLifestyle,
        'cooking' => catCooking,
        'travel' => catTravel,
        'cars' => catCars,
        'education' => catEducation,
        'business' => catBusiness,
        'finance' => catFinance,
        'marketing' => catMarketing,
        'ecommerce' => catEcommerce,
        'art' => catArt,
        'music' => catMusic,
        'entertainment' => catEntertainment,
        'family' => catFamily,
        'photography' => catPhotography,
        _ => id,
      };
}
