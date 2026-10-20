import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:x_ten/core/catalog/influencer_categories.dart';
import 'package:x_ten/core/localization/category_labels.dart';
import 'package:x_ten/core/localization/localization_extension.dart';

/// Browse influencers by professional category.
class InfluencerCategoriesScreen extends StatelessWidget {
  const InfluencerCategoriesScreen({super.key});

  static const Color _gold = Color(0xFFE5C158);
  static const Color _background = Color(0xFF0A0A0A);

  static IconData _icon(String id) => switch (id) {
        'acting' => Icons.theater_comedy_outlined,
        'music' => Icons.music_note_outlined,
        'technology' => Icons.devices_outlined,
        'cooking' => Icons.restaurant_outlined,
        'sports' => Icons.sports_soccer_outlined,
        'beauty' => Icons.face_retouching_natural_outlined,
        'health' => Icons.health_and_safety_outlined,
        'publicFigures' => Icons.record_voice_over_outlined,
        'education' => Icons.school_outlined,
        'cars' => Icons.directions_car_outlined,
        'travel' => Icons.flight_outlined,
        'business' => Icons.business_center_outlined,
        'agriculture' => Icons.agriculture_outlined,
        'industry' => Icons.factory_outlined,
        'comedy' => Icons.sentiment_very_satisfied_outlined,
        'realEstate' => Icons.apartment_outlined,
        'ecommerce' => Icons.shopping_bag_outlined,
        _ => Icons.category_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _background,
        appBar: AppBar(
          backgroundColor: _background,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'المؤثرون حسب المجالات',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.25,
          ),
          itemCount: InfluencerCategories.ids.length,
          itemBuilder: (context, index) {
            final category = InfluencerCategories.ids[index];

            return Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                onTap: () {
                  context.push(
                    '/advertiser/influencers?category=$category',
                  );
                },
                borderRadius: BorderRadius.circular(18),
                child: Ink(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color(0xFF1B1B1B),
                        Color(0xFF121212),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: _gold.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _gold.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _icon(category),
                          color: _gold,
                          size: 24,
                        ),
                      ),
                      Text(
                        l10n.category(category),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
