import 'package:flutter/material.dart';
import 'package:x_ten/features/influencer_registration/presentation/pages/onboarding/audience_targeting_screen.dart';

class InfluenceStyleScreen extends StatefulWidget {
  const InfluenceStyleScreen({super.key});

  @override
  State<InfluenceStyleScreen> createState() => _InfluenceStyleScreenState();
}

class _InfluenceStyleScreenState extends State<InfluenceStyleScreen> {
  // Theme Colors
  final Color _bgDark = const Color(0xFF101010);
  final Color _cardDark = const Color(0xFF1A1A1A);
  final Color _gold = const Color(0xFFE2C044);
  final Color _textGrey = const Color(0xFFA0A0A0);

  // State to track selected styles (Set allows multiple selections)
  final Set<String> _selectedStyles = {'ترفيهي'}; // Pre-selected based on your image

  // Data for the influence styles
  final List<Map<String, dynamic>> _styleOptions = [
    {
      'title': 'إقناعي',
      'subtitle': 'التركيز على تحويل الجمهور باتخاذ قرارات من خلال حجج منطقية وجذابة.',
      'icon': Icons.campaign_outlined,
    },
    {
      'title': 'ترفيهي',
      'subtitle': 'بناء علاقة قوية من خلال الفكاهة، القصص، والمحتوى البصري الممتع.',
      'icon': Icons.theater_comedy_outlined,
    },
    {
      'title': 'تعليمي',
      'subtitle': 'تقديم قيمة معرفية، نصائح، ودروس متخصصة تزيد من وعي المتابع.',
      'icon': Icons.school_outlined,
    },
    {
      'title': 'تحفيزي وإلهامي',
      'subtitle': 'دفع المتابعين نحو التغيير الإيجابي وتحقيق الأهداف الشخصية والمهنية.',
      'icon': Icons.auto_awesome,
    },
    {
      'title': 'سرد قصصي',
      'subtitle': 'مشاركة التجارب الشخصية وبناء مجتمع مترابط عبر الحكايات.',
      'icon': Icons.menu_book,
    },
  ];

  void _toggleSelection(String title) {
    setState(() {
      if (_selectedStyles.contains(title)) {
        _selectedStyles.remove(title);
      } else {
        _selectedStyles.add(title);
      }
    });
  }

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
            IconButton(
              icon: Icon(Icons.help_outline, color: _gold),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            // 1. Top Progress Bar
            Row(
              children: [
                Expanded(flex: 8, child: Container(height: 3, color: _gold)),
                Expanded(flex: 2, child: Container(height: 3, color: Colors.grey[800])),
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
                      'أسلوب التأثير',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'حدد الطريقة التي تتواصل بها مع جمهورك. يساعدنا هذا في\nمطابقتك مع العلامات التجارية التي تبحث عن نبرة صوتك\nالفريدة.',
                      style: TextStyle(color: _textGrey, fontSize: 13, height: 1.6),
                    ),
                    const SizedBox(height: 32),

                    // 3. Style Selection Cards
                    ..._styleOptions.map((option) {
                      return _buildStyleCard(
                        title: option['title'],
                        subtitle: option['subtitle'],
                        icon: option['icon'],
                      );
                    }),
                    const SizedBox(height: 16),

                    // 4. Info Box (Multiple selection hint)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: _gold, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'يمكنك اختيار أكثر من أسلوب. ننصح باختيار الأنماط\nالتي تعكس محتواك الحالي بدقة لضمان أفضل نتائج\nالتعاون.',
                            style: TextStyle(
                              color: _textGrey,
                              fontSize: 12,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
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
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: () {},
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
                          MaterialPageRoute(builder: (context) => const AudienceTargetingScreen()),
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

  // --- Helper Widget for the Cards ---
  Widget _buildStyleCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedStyles.contains(title);

    return GestureDetector(
      onTap: () => _toggleSelection(title),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Stack(
          children: [
            // Main Card Background
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                color: _cardDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? _gold : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  // Icon in a rounded box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? _gold : const Color(0xFF252525), // Gold if selected, dark grey if not
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? _bgDark : _gold, // Invert icon color based on selection
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      color: _gold, // The title always stays gold in your design
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _textGrey,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Selected Checkmark Badge (Top Left in RTL)
            if (isSelected)
              Positioned(
                top: 16,
                left: 16, // Top-left position
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_circle, color: _gold, size: 22),
                ),
              ),
          ],
        ),
      ),
    );
  }
}