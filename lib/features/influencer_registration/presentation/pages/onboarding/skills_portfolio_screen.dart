import 'package:flutter/material.dart';
import 'package:x_ten/features/onboarding_registration/presentation/pages/registration_success_screen.dart';

class SkillsPortfolioScreen extends StatefulWidget {
  const SkillsPortfolioScreen({super.key});

  @override
  State<SkillsPortfolioScreen> createState() => _SkillsPortfolioScreenState();
}

class _SkillsPortfolioScreenState extends State<SkillsPortfolioScreen> {
  // Theme Colors
  final Color _bgDark = const Color(0xFF101010);
  final Color _cardDark = const Color(0xFF1A1A1A);
  final Color _gold = const Color(0xFFE2C044);
  final Color _textGrey = const Color(0xFFA0A0A0);

  // State to track selected skill
  String _selectedSkill = 'التعليق الصوتي (Voice Over)';

  // Data for skills
  final List<Map<String, dynamic>> _skills = [
    {
      'title': 'التعليق الصوتي (Voice Over)',
      'icon': Icons.mic_none,
    },
    {
      'title': 'المونتاج السينمائي (Editing)',
      'icon': Icons.movie_creation_outlined,
    },
    {
      'title': 'كتابة المحتوى (Copywriting)',
      'icon': Icons.edit_note,
    },
    {
      'title': 'التصوير الفوتوغرافي',
      'icon': Icons.camera_alt_outlined,
    },
    {
      'title': 'استراتيجية المحتوى',
      'icon': Icons.trending_up,
    },
  ];

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
            'المهارات ومعرض الأعمال',
            style: TextStyle(
              color: _gold,
              fontSize: 16,
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
                    // --- SECTION 1: Creative Skills ---
                    const Text(
                      'المهارات الإبداعية',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'اختر المهارات التي تميزك لتعزيز ظهورك للعلامات التجارية.',
                      style: TextStyle(color: _textGrey, fontSize: 13),
                    ),
                    const SizedBox(height: 24),

                    // Skills List
                    ..._skills.map((skill) => _buildSkillButton(
                      title: skill['title'],
                      icon: skill['icon'],
                    )),
                    const SizedBox(height: 40),

                    // --- SECTION 2: Portfolio ---
                    const Text(
                      'معرض الأعمال (Portfolio)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'أبهرنا بأفضل ما لديك. قم برفع صور أو فيديوهات تعكس جودة عملك.',
                      style: TextStyle(color: _textGrey, fontSize: 13),
                    ),
                    const SizedBox(height: 24),

                    // Portfolio Upload Grid
                    Row(
                      children: [
                        // Right Column (in RTL) - Stacked video & link boxes
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              _buildUploadBox(
                                title: 'رفع فيديو',
                                icon: Icons.videocam_outlined,
                                height: 140,
                                bgImageUrl: 'https://images.unsplash.com/photo-1574717024653-61fd2cf4d44d?auto=format&fit=crop&q=80&w=300',
                              ),
                              const SizedBox(height: 16),
                              _buildUploadBox(
                                title: 'رابط\n(Behance/Drive)',
                                icon: Icons.link,
                                height: 140,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Left Column (in RTL) - Tall photo box
                        Expanded(
                          flex: 1,
                          child: _buildUploadBox(
                            title: 'رفع صور',
                            icon: Icons.add_a_photo_outlined,
                            height: 296, // 140 + 140 + 16 (spacing)
                            bgImageUrl: 'https://images.unsplash.com/photo-1603425013520-e0b30e6e37dc?auto=format&fit=crop&q=80&w=300',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Uploaded File List Item
                    _buildUploadedFileItem(
                      fileName: 'مشروع_العلامة_التجارية.jpg',
                      fileSize: '5.2 MB',
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // --- BOTTOM NAVIGATION BUTTONS ---
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
                          MaterialPageRoute(
                            builder: (context) => const RegistrationSuccessScreen(),
                          ),
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

  Widget _buildSkillButton({required String title, required IconData icon}) {
    final isSelected = _selectedSkill == title;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedSkill = title);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? _gold : _cardDark,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Text on right, icon on left in RTL
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            Icon(
              icon,
              color: isSelected ? Colors.black : _gold,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadBox({
    required String title,
    required IconData icon,
    required double height,
    String? bgImageUrl,
  }) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: _cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _gold.withValues(alpha:0.3),
          width: 1.5,
          // Note: Flutter doesn't natively support dashed borders in standard BoxDecoration.
          // Using a subtle solid border with opacity to mimic the design's bounds.
        ),
        image: bgImageUrl != null
            ? DecorationImage(
          image: NetworkImage(bgImageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha:0.75), // Darken image so text pops
            BlendMode.darken,
          ),
        )
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: _gold, size: 32),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _gold,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadedFileItem({required String fileName, required String fileSize}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _cardDark,
        borderRadius: BorderRadius.circular(8),
        // Add the gold accent border on the right (since it's RTL, it acts as a starting edge accent)
        border: Border(
          right: BorderSide(color: _gold, width: 4),
        ),
      ),
      child: Row(
        children: [
          // Thumbnail Placeholder
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(6),
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1611162617474-5b21e879e113?auto=format&fit=crop&q=80&w=100'), // Generic logo/graphic thumbnail
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // File Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  fileSize,
                  style: TextStyle(color: _textGrey, fontSize: 11),
                ),
              ],
            ),
          ),

          // Delete Button
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
            onPressed: () {
              // Delete action
            },
          ),
        ],
      ),
    );
  }
}