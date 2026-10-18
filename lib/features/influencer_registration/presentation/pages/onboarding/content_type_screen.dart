import 'package:flutter/material.dart';
import 'package:x_ten/features/influencer_registration/presentation/pages/onboarding/influence_style_screen.dart';

class ContentTypeScreen extends StatefulWidget {
  const ContentTypeScreen({super.key});

  @override
  State<ContentTypeScreen> createState() => _ContentTypeScreenState();
}

class _ContentTypeScreenState extends State<ContentTypeScreen> {
  // Theme Colors
  final Color _bgDark = const Color(0xFF101010);
  final Color _cardDark = const Color(0xFF1A1A1A);
  final Color _gold = const Color(0xFFE2C044);
  final Color _textGrey = const Color(0xFFA0A0A0);

  // State to track selected content types
  final Set<String> _selectedTypes = {'فيديوهات طويلة'}; // Pre-selected based on image
  final int _maxSelection = 7;

  // Data for the content types
  final List<Map<String, dynamic>> _contentOptions = [
    {
      'title': 'فيديوهات طويلة',
      'subtitle': 'YouTube, Documentaries',
      'icon': Icons.movie_creation_outlined,
    },
    {
      'title': 'فيديوهات قصيرة',
      'subtitle': 'Reels, TikTok, Shorts',
      'icon': Icons.bolt_outlined,
    },
    {
      'title': 'قصص يومية',
      'subtitle': 'Instagram Stories, Snapchat',
      'icon': Icons.history_outlined,
    },
    {
      'title': 'بودكاست',
      'subtitle': 'Audio content, Interviews',
      'icon': Icons.mic_none_outlined,
    },
    {
      'title': 'تصوير فوتوغرافي',
      'subtitle': 'High-end visuals, Portfolios',
      'icon': Icons.camera_alt_outlined,
    },
    {
      'title': 'مقالات ومحتوى مكتوب',
      'subtitle': 'Blogs, Newsletters',
      'icon': Icons.article_outlined,
    },
    {
      'title': 'بث مباشر',
      'subtitle': 'Twitch, Live interaction',
      'icon': Icons.sensors,
    },
    {
      'title': 'محتوى تعليمي',
      'subtitle': 'Courses, How-to guides',
      'icon': Icons.school_outlined,
    },
  ];

  void _toggleSelection(String title) {
    setState(() {
      if (_selectedTypes.contains(title)) {
        _selectedTypes.remove(title);
      } else {
        if (_selectedTypes.length < _maxSelection) {
          _selectedTypes.add(title);
        } else {
          // Optional: Show a snackbar if they try to select more than 7
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('يمكنك اختيار $_maxSelection أنواع كحد أقصى', style: const TextStyle(fontFamily: 'Cairo')),
              backgroundColor: Colors.redAccent,
              duration: const Duration(seconds: 2),
            ),
          );
        }
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
                Expanded(flex: 7, child: Container(height: 3, color: _gold)),
                Expanded(flex: 3, child: Container(height: 3, color: Colors.grey[800])),
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
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo', // Fallback font if you have one set
                          color: Colors.white,
                          height: 1.4,
                        ),
                        children: [
                          const TextSpan(text: 'ما هو '),
                          TextSpan(
                            text: 'نوع المحتوى الذي',
                            style: TextStyle(
                              color: _bgDark, // Dark text
                              backgroundColor: _gold, // Gold highlight background
                            ),
                          ),
                          const TextSpan(text: '\nتتخصص به؟'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'اختر حتى 7 أنواع تصف أسلوبك الإبداعي لنوفر لك الفرص\nالمناسبة.',
                      style: TextStyle(color: _textGrey, fontSize: 13, height: 1.6),
                    ),
                    const SizedBox(height: 32),

                    // 3. Content Type Selection Cards
                    ..._contentOptions.map((option) {
                      return _buildContentCard(
                        title: option['title'],
                        subtitle: option['subtitle'],
                        icon: option['icon'],
                      );
                    }),

                    const SizedBox(height: 16),

                    // 4. Decorative Bottom Image (Camera/Tablet placeholder)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1542744094-3a31f272c490?auto=format&fit=crop&q=80&w=600', // Placeholder resembling a creative setup
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        color: Colors.black.withValues(alpha:0.4), // Darken the image slightly to blend in
                        colorBlendMode: BlendMode.darken,
                      ),
                    ),
                    const SizedBox(height: 20),
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
                      onPressed: () {
                        Navigator.pop(context); // Returns to the previous screen
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
                          MaterialPageRoute(builder: (context) => const InfluenceStyleScreen()),
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
  Widget _buildContentCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedTypes.contains(title);

    return GestureDetector(
      onTap: () => _toggleSelection(title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? _gold : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Icon with optional checkmark badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  color: isSelected ? _gold : Colors.grey[500],
                  size: 28,
                ),
                if (isSelected)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check_circle, color: _gold, size: 14),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: _textGrey,
                      fontSize: 12,
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
}