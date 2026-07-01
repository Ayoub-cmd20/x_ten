import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'content_type_screen.dart'; // Adjust the file path if it is located in a different folder

class InfluencerClassificationScreen extends StatefulWidget {
  const InfluencerClassificationScreen({super.key});

  @override
  State<InfluencerClassificationScreen> createState() => _InfluencerClassificationScreenState();
}

class _InfluencerClassificationScreenState extends State<InfluencerClassificationScreen> {
  // Theme Colors
  final Color _bgDark = const Color(0xFF101010);
  final Color _cardDark = const Color(0xFF1A1A1A);
  final Color _gold = const Color(0xFFE2C044);
  final Color _textGrey = const Color(0xFFA0A0A0);

  // State Variables
  String _selectedAudience = 'Macro'; // Default selected as per image
  String _selectedGender = 'أنثى'; // Default selected as per image
  String _selectedPlatform = 'تيك توك'; // Default selected as per image

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
            'التسجيل',
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
                Expanded(flex: 6, child: Container(height: 3, color: _gold)),
                Expanded(flex: 4, child: Container(height: 3, color: Colors.grey[800])),
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
                      'تصنيف المؤثر',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'حدد هويتك الرقمية وحجم جمهورك لضمان وصول العلامات\nالتجارية المناسبة لملفك الشخصي.',
                      style: TextStyle(color: _textGrey, fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 32),

                    // 3. Audience Size Section
                    _buildSectionHeader('حجم الجمهور'),
                    const SizedBox(height: 16),
                    _buildAudienceCard(
                      id: 'Nano',
                      title: 'مؤثر (Nano)',
                      range: '1K - 10K',
                      icon: Icons.people_outline,
                      activeBars: 2,
                    ),
                    _buildAudienceCard(
                      id: 'Micro',
                      title: 'مؤثر (Micro)',
                      range: '10K - 100K',
                      icon: Icons.groups_outlined,
                      activeBars: 3,
                    ),
                    _buildAudienceCard(
                      id: 'Macro',
                      title: 'مؤثر (Macro)',
                      range: '100K - 1M',
                      icon: Icons.stars,
                      activeBars: 4,
                    ),
                    _buildAudienceCard(
                      id: 'Mega',
                      title: 'مؤثر (Mega)',
                      range: '1M+ متابع',
                      icon: Icons.public,
                      activeBars: 5,
                    ),
                    const SizedBox(height: 32),

                    // 4. Gender Section
                    _buildSectionHeader('الجنس'),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildGenderOption('ذكر', Icons.male),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildGenderOption('أنثى', Icons.female),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // 5. Primary Platform Section
                    _buildSectionHeader('المنصة الأساسية'),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildPlatformChip('انستغرام', FontAwesomeIcons.instagram),
                        _buildPlatformChip('تيك توك', FontAwesomeIcons.tiktok),
                        _buildPlatformChip('يوتيوب', FontAwesomeIcons.youtube),
                        _buildPlatformChip('سناب شات', FontAwesomeIcons.snapchat),
                        _buildPlatformChip('إكس (تويتر)', FontAwesomeIcons.xTwitter),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // 6. Bottom Navigation Buttons
            Container(
              padding: const EdgeInsets.all(20),
              color: _bgDark,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context); // Returns the user to the previous step
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
                          MaterialPageRoute(builder: (context) => const ContentTypeScreen()),
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

  // Custom Section Header with line
  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Divider(color: Colors.grey[800], thickness: 1),
        ),
      ],
    );
  }

  // Audience Size Card Builder
  Widget _buildAudienceCard({
    required String id,
    required String title,
    required String range,
    required IconData icon,
    required int activeBars,
  }) {
    final isSelected = _selectedAudience == id;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedAudience = id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? _gold : Colors.transparent, width: 1.5),
        ),
        child: Row(
          children: [
            // Radio Button Indicator
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? _gold : Colors.grey[600]!, width: 2),
              ),
              child: isSelected
                  ? Center(child: Container(width: 10, height: 10, decoration: BoxDecoration(color: _gold, shape: BoxShape.circle)))
                  : null,
            ),
            const Spacer(),

            // Text and Chart Bars
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    _buildChartBars(activeBars),
                  ],
                ),
                const SizedBox(height: 4),
                Text(range, style: TextStyle(color: _textGrey, fontSize: 12)),
              ],
            ),
            const SizedBox(width: 16),

            // Category Icon
            Icon(icon, color: isSelected ? _gold : Colors.grey[600], size: 28),
          ],
        ),
      ),
    );
  }

  // Helper to draw the little signal bars
  Widget _buildChartBars(int activeCount) {
    return Row(
      children: List.generate(5, (index) {
        return Container(
          margin: const EdgeInsets.only(left: 2),
          width: 4,
          height: 12 + (index * 2).toDouble(), // Escalating heights
          decoration: BoxDecoration(
            color: index < activeCount ? Colors.white : Colors.grey[800],
            borderRadius: BorderRadius.circular(1),
          ),
        );
      }),
    );
  }

  // Gender Option Builder
  Widget _buildGenderOption(String title, IconData icon) {
    final isSelected = _selectedGender == title;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedGender = title);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: _cardDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? _gold : Colors.transparent, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? _gold : Colors.grey[500], size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? _gold : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Platform Chip Builder
  // Platform Chip Builder (UPDATED)
  Widget _buildPlatformChip(String title, dynamic icon) { // Changed IconData to dynamic
    final isSelected = _selectedPlatform == title;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedPlatform = title);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _cardDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? _gold : Colors.transparent, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Changed standard Icon to FaIcon
            FaIcon(icon, color: isSelected ? _gold : Colors.grey[500], size: 16),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? _gold : Colors.white,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}