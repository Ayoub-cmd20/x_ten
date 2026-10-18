import 'package:flutter/material.dart';
import 'package:x_ten/features/influencer_registration/presentation/pages/onboarding/social_accounts_screen.dart'; // Adjust path if necessary

class SectorsSelectionScreen extends StatefulWidget {
  const SectorsSelectionScreen({super.key});

  @override
  State<SectorsSelectionScreen> createState() => _SectorsSelectionScreenState();
}

class _SectorsSelectionScreenState extends State<SectorsSelectionScreen> {
  final Color _bgDark = const Color(0xFF101010);
  final Color _cardDark = const Color(0xFF1A1A1A);
  final Color _gold = const Color(0xFFE2C044);
  final Color _textGrey = const Color(0xFFA0A0A0);

  // Track the currently expanded sector index. (3 corresponds to Fashion & Beauty in our list)
  int _expandedIndex = 3;

  // Track selected subcategories (Set of strings)
  final Set<String> _selectedSubcategories = {
    'الموضة',
    'الجمال',
  };

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _bgDark,
        appBar: AppBar(
          backgroundColor: _bgDark,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward, color: Color(0xFFE2C044)),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'القطاعات',
            style: TextStyle(
              color: _gold,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline, color: Color(0xFFE2C044)),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            // 1. Top Progress Bar
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Container(height: 3, color: _gold),
                ),
                Expanded(
                  flex: 2,
                  child: Container(height: 3, color: Colors.grey[800]),
                ),
              ],
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. Header
                    const Text(
                      'حدد هويتك',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: _textGrey, fontSize: 13, height: 1.5, fontFamily: 'Cairo'),
                        children: [
                          const TextSpan(text: 'اختر '),
                          TextSpan(text: 'قطاعين', style: TextStyle(color: _gold, fontWeight: FontWeight.bold)),
                          const TextSpan(text: ' وفئتين لكل قطاع. أو قم بالترقية لاختيار '),
                          TextSpan(text: '3 قطاعات و 3 فئات.', style: TextStyle(color: _gold, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 3. Premium Upgrade Banner
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: _cardDark,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _gold.withValues(alpha:0.3), width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.workspace_premium, color: _gold, size: 24),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'باقة المحترفين: +1 قطاع، +1 فئة',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _gold,
                              foregroundColor: Colors.black,
                              minimumSize: const Size(60, 30),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            child: const Text('ترقية', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 4. Sector List
                    _buildSectorList(),
                  ],
                ),
              ),
            ),

            // 5. Bottom Navigation Buttons
            Container(
              padding: const EdgeInsets.all(20),
              color: _bgDark,
              child: Row(
                children: [
                  // Previous Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey[800]!),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chevron_right, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text('السابق', style: TextStyle(color: Colors.white, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Continue Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SocialAccountsScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE5C158),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('المتابعة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Icon(Icons.chevron_left, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build the list of sectors
  Widget _buildSectorList() {
    final List<Map<String, dynamic>> sectors = [
      {'title': 'الحياة اليومية', 'icon': Icons.home_outlined, 'subcategories': []},
      {'title': 'المأكولات والمشروبات', 'icon': Icons.restaurant, 'subcategories': []},
      {'title': 'السفر والتجارب', 'icon': Icons.flight_takeoff, 'subcategories': []},
      {
        'title': 'الموضة والجمال',
        'icon': Icons.auto_awesome,
        'subcategories': ['الموضة', 'الجمال', 'تنسيق الملابس', 'العناية بالبشرة', 'الشعر', 'العطور', 'التجميل']
      },
      {'title': 'الصحة واللياقة', 'icon': Icons.health_and_safety_outlined, 'subcategories': []},
      {'title': 'الرياضة', 'icon': Icons.fitness_center, 'subcategories': []},
      {'title': 'التكنولوجيا', 'icon': Icons.computer, 'subcategories': []},
      {'title': 'المال والأعمال', 'icon': Icons.business_center_outlined, 'subcategories': []},
      {'title': 'التعليم والعلوم', 'icon': Icons.school_outlined, 'subcategories': []},
      {'title': 'الإعلام والمحتوى', 'icon': Icons.movie_creation_outlined, 'subcategories': []},
      {'title': 'الترفيه والفنون', 'icon': Icons.theater_comedy_outlined, 'subcategories': []},
      {'title': 'المجتمع والقيم', 'icon': Icons.people_outline, 'subcategories': []},
      {'title': 'الألعاب الإلكترونية', 'icon': Icons.sports_esports_outlined, 'subcategories': []},
      {'title': 'السيارات والنقل', 'icon': Icons.directions_car_outlined, 'subcategories': []},
      {'title': 'الطبيعة والهوايات', 'icon': Icons.park_outlined, 'subcategories': []},
    ];

    return Column(
      children: List.generate(sectors.length, (index) {
        final sector = sectors[index];
        final isExpanded = _expandedIndex == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              // Toggle expansion
              _expandedIndex = isExpanded ? -1 : index;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _cardDark,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isExpanded ? _gold : Colors.transparent,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row (Title & Icon)
                Row(
                  children: [
                    Icon(sector['icon'], color: isExpanded ? _gold : Colors.white, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        sector['title'],
                        style: TextStyle(
                          color: isExpanded ? _gold : Colors.white,
                          fontSize: 15,
                          fontWeight: isExpanded ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (isExpanded)
                      Row(
                        children: [
                          Text('مختار', style: TextStyle(color: _textGrey, fontSize: 12)),
                          const SizedBox(width: 4),
                          Icon(Icons.keyboard_arrow_up, color: _textGrey, size: 20),
                        ],
                      )
                    else
                      Icon(Icons.keyboard_arrow_down, color: _textGrey, size: 20),
                  ],
                ),
                // Expanded Content (Subcategories Grid)
                if (isExpanded && (sector['subcategories'] as List).isNotEmpty) ...[
                  const SizedBox(height: 20),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final subcats = sector['subcategories'] as List<String>;
                      // Calculate width for 2 columns with a small gap
                      final itemWidth = (constraints.maxWidth - 12) / 2;

                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: subcats.map((subcat) {
                          final isSelected = _selectedSubcategories.contains(subcat);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedSubcategories.remove(subcat);
                                } else {
                                  _selectedSubcategories.add(subcat);
                                }
                              });
                            },
                            child: Container(
                              width: itemWidth,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: isSelected ? _gold : Colors.grey[800]!),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                subcat,
                                style: TextStyle(
                                  color: isSelected ? _gold : Colors.grey[400],
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }
}