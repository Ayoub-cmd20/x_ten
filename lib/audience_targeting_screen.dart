import 'package:flutter/material.dart';
import 'skills_portfolio_screen.dart';

class AudienceTargetingScreen extends StatefulWidget {
  const AudienceTargetingScreen({super.key});

  @override
  State<AudienceTargetingScreen> createState() => _AudienceTargetingScreenState();
}

class _AudienceTargetingScreenState extends State<AudienceTargetingScreen> {
  // Theme Colors
  final Color _bgDark = const Color(0xFF101010);
  final Color _cardDark = const Color(0xFF1A1A1A);
  final Color _gold = const Color(0xFFE2C044);
  final Color _textGrey = const Color(0xFFA0A0A0);

  // State Variables
  String _selectedAgeGroup = '25 - 34'; // Pre-selected
  final Set<String> _selectedGenders = {'إناث', 'ذكور'}; // Both pre-selected
  String _selectedScope = 'محلي'; // Pre-selected

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
            icon: Icon(Icons.arrow_forward, color: _gold),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'التسجيل',
            style: TextStyle(
              color: _gold,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            Row(
              children: [
                Text('ASSET', style: TextStyle(color: _gold, fontSize: 14, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.help_outline, color: _gold),
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
        body: Column(
          children: [
            // 1. Top Progress Bar
            Row(
              children: [
                Expanded(flex: 9, child: Container(height: 3, color: _gold)),
                Expanded(flex: 1, child: Container(height: 3, color: Colors.grey[800])),
              ],
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. Header Title & Subtitle
                    const Text(
                      'استهداف الجمهور',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'حدد ملامح جمهورك بدقة. نحن نستخدم تقنيات متطورة\nلضمان وصول حملتك للأشخاص الذين يهتمون حقاً بما\nتقدمه.',
                      style: TextStyle(color: _textGrey, fontSize: 13, height: 1.6),
                    ),
                    const SizedBox(height: 32),

                    // 3. Age Groups Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _cardDark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.people_outline, color: _gold, size: 20),
                              const SizedBox(width: 10),
                              const Text('الفئات العمرية', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(child: _buildAgeOption('18 - 24', 'الجيل الجديد')),
                              const SizedBox(width: 12),
                              Expanded(child: _buildAgeOption('25 - 34', 'المحترفون')),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: _buildAgeOption('35 - 44', 'الخبراء')),
                              const SizedBox(width: 12),
                              Expanded(child: _buildAgeOption('+45', 'كبار الشخصيات')),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 4. Gender Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _cardDark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('الجنس', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          _buildGenderCheckbox('إناث', Icons.female),
                          const SizedBox(height: 12),
                          _buildGenderCheckbox('ذكور', Icons.male),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 5. Geographic Scope Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _cardDark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('النطاق الجغرافي', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(child: _buildScopeToggle('محلي')),
                              const SizedBox(width: 8),
                              Expanded(child: _buildScopeToggle('إقليمي')),
                              const SizedBox(width: 8),
                              Expanded(child: _buildScopeToggle('دولي')),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Search Field
                          Container(
                            decoration: BoxDecoration(
                              color: _bgDark,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[800]!),
                            ),
                            child: TextField(
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'ابحث عن مدينة أو دولة...',
                                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                suffixIcon: Icon(Icons.search, color: Colors.grey[500], size: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // 6. Audience Summary Card
                    _buildAudienceSummaryCard(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // 7. Bottom Navigation Buttons
            Container(
              padding: const EdgeInsets.all(20),
              color: _bgDark,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: _gold),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chevron_right, color: _gold, size: 20),
                          const SizedBox(width: 8),
                          Text('السابق', style: TextStyle(color: _gold, fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SkillsPortfolioScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _gold,
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

  // --- Helper Widgets ---

  Widget _buildAgeOption(String ageRange, String label) {
    final isSelected = _selectedAgeGroup == ageRange;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedAgeGroup = ageRange);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? _gold.withOpacity(0.1) : _bgDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? _gold : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Text(
              ageRange,
              style: TextStyle(
                color: isSelected ? _gold : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? _gold : _textGrey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderCheckbox(String title, IconData icon) {
    final isSelected = _selectedGenders.contains(title);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedGenders.remove(title);
          } else {
            _selectedGenders.add(title);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _bgDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? _gold : Colors.grey[800]!, width: 1),
        ),
        child: Row(
          children: [
            // Custom Checkbox
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? _gold : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: isSelected ? _gold : Colors.grey[600]!),
              ),
              child: isSelected ? const Icon(Icons.check, color: Colors.black, size: 16) : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            Icon(icon, color: Colors.grey[500], size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildScopeToggle(String title) {
    final isSelected = _selectedScope == title;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedScope = title);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? _gold : _bgDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? _gold : Colors.grey[800]!),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.black : _textGrey,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildAudienceSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        color: _cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[900]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ملخص الجمهور', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                // Stats Row 1
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('الوصول المتوقع', style: TextStyle(color: _textGrey, fontSize: 13)),
                    Text('1.2M - 1.8M', style: TextStyle(color: _gold, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),

                // Stats Row 2
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('التفاعل المقدر', style: TextStyle(color: _textGrey, fontSize: 13)),
                    Text('4.5%', style: TextStyle(color: _gold, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 24),

                // Checklist
                _buildSummaryCheckItem('المملكة العربية السعودية، الإمارات'),
                const SizedBox(height: 8),
                _buildSummaryCheckItem('الفئة العمرية: 25 - 45 عاماً'),
                const SizedBox(height: 8),
                _buildSummaryCheckItem('اهتمامات: الرفاهية، التكنولوجيا، السفر'),
              ],
            ),
          ),

          // Decorative Wave Image (Bottom of the card)
          ClipRRect(
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
            child: Image.network(
              'https://images.unsplash.com/photo-1550684848-fac1c5b4e853?auto=format&fit=crop&q=80&w=600', // Gold tech/wave pattern placeholder
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
              color: _gold.withOpacity(0.3), // Tint it gold to match theme
              colorBlendMode: BlendMode.modulate,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCheckItem(String text) {
    return Row(
      children: [
        Icon(Icons.check_circle_outline, color: _gold, size: 16),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
      ],
    );
  }
}