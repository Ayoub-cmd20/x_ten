import 'package:flutter/material.dart';

import 'package:x_ten/features/marketplace/data/influencers_demo_data.dart';
import 'package:x_ten/features/marketplace/domain/models/influencer_category.dart';
import 'package:x_ten/features/marketplace/presentation/pages/category_influencers_screen.dart';

class InfluencerCategoriesScreen extends StatelessWidget {
  const InfluencerCategoriesScreen({super.key});

  static const Color gold = Color(0xFFE5C158);
  static const Color background = Color(0xFF0A0A0A);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: const Text(
            'المؤثرون حسب المجالات',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: influencerCategories.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: 135,
              ),
              itemBuilder: (context, index) {
                final category = influencerCategories[index];

                return _CategoryCard(
                  category: category,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryInfluencersScreen(
                          category: category,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final InfluencerCategory category;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.onTap,
  });

  static const Color gold = Color(0xFFE5C158);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: gold.withValues(alpha: 0.15),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFF1D1D1D),
                Color(0xFF121212),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: gold.withValues(alpha: 0.20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: gold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    category.icon,
                    color: gold,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  category.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.4,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}