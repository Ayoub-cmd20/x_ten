import 'package:flutter/material.dart';
import 'influencer_classification_screen.dart';

class SocialAccountsScreen extends StatefulWidget {
  const SocialAccountsScreen({super.key});

  @override
  State<SocialAccountsScreen> createState() => _SocialAccountsScreenState();
}

class _SocialAccountsScreenState extends State<SocialAccountsScreen> {
  final Color _bgDark = const Color(0xFF0A0A0A);
  final Color _cardDark = const Color(0xFF151515);
  final Color _gold = const Color(0xFFE5C158);
  final Color _textGrey = const Color(0xFFA0A0A0);

  // Set to manage selected skills
  final Set<String> _selectedSkills = {
    'صناعة المحتوى',
    'التصوير الاحترافي',
  };

  final List<String> _allSkills = [
    'صناعة المحتوى',
    'التصوير الاحترافي',
    'تقديم الفعاليات',
    'التمثيل الإعلاني',
    'إدارة العلامات التجارية',
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
          title: const Text(
            'حسابات التواصل\nوالجمهور',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // 1. Top Progress Bar (Almost complete)
            Row(
              children: [
                Expanded(flex: 9, child: Container(height: 3, color: _gold)),
                Expanded(flex: 1, child: Container(height: 3, color: Colors.grey[800])),
              ],
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- SECTION 1: Social Platforms ---
                    const Text(
                      'ربط المنصات',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'أضف روابط حساباتك وسنقوم بتحليل الجمهور تلقائياً',
                      style: TextStyle(color: _textGrey, fontSize: 13),
                    ),
                    const SizedBox(height: 20),

                    // URL Input Field with Verify Button
                    _buildUrlInputField(),
                    const SizedBox(height: 24),

                    // Verified Account Card (Instagram)
                    _buildVerifiedAccountCard(),
                    const SizedBox(height: 16),

                    // Pending/Connecting Account Card (TikTok)
                    _buildPendingAccountCard(),
                    const SizedBox(height: 40),

                    // --- SECTION 2: Skills ---
                    const Text(
                      'المهارات',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 12,
                      children: _allSkills.map((skill) => _buildSkillChip(skill)).toList(),
                    ),
                    const SizedBox(height: 40),

                    // --- SECTION 3: Portfolio ---
                    const Text(
                      'معرض الأعمال',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildPortfolioGrid(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // --- BOTTOM NAVIGATION BUTTON ---
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _bgDark,
                border: Border(top: BorderSide(color: Colors.grey[900]!, width: 1)),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InfluencerClassificationScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _gold,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'التالي',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildUrlInputField() {
    return Container(
      decoration: BoxDecoration(
        color: _cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'https://instagram.com/yourprofile',
          hintStyle: TextStyle(color: Colors.grey[700], fontSize: 13),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          // Suffix Icon becomes the left side in RTL
          suffixIcon: Padding(
            padding: const EdgeInsets.all(6.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: _gold.withOpacity(0.15), // Semi-transparent gold
                foregroundColor: _gold,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              child: const Text('تحقق', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerifiedAccountCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&q=80&w=100'), // Placeholder avatar
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('@Influencer_Vip', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text('انستغرام - تم التحقق', style: TextStyle(color: _textGrey, fontSize: 12)),
                ],
              ),
              const Spacer(),
              Icon(Icons.verified, color: _gold, size: 24),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('متابعين', '125K'),
              _buildVerticalDivider(),
              _buildStatItem('تفاعل', '4.8%'),
              _buildVerticalDivider(),
              _buildStatItem('المنشورات', '842'),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'رائد في مجال الموضة والأناقة، متخصص في استعراض العلامات التجارية الفاخرة وتقديم محتوى حصري للمتابعين.',
            style: TextStyle(color: Colors.grey[400], fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: _textGrey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey[800],
    );
  }

  Widget _buildPendingAccountCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[900],
                backgroundImage: const NetworkImage('https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&q=80&w=100'), // Placeholder
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('جاري الربط...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text('تيك توك', style: TextStyle(color: _textGrey, fontSize: 12)),
                ],
              ),
              const Spacer(),
              Icon(Icons.sync, color: Colors.grey[600], size: 24),
            ],
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: 0.65, // 65% loaded representation
              backgroundColor: Colors.grey[900],
              valueColor: AlwaysStoppedAnimation<Color>(_gold),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'يتم الان جلب إحصائيات الجمهور والموقع الجغرافي',
            style: TextStyle(color: Colors.grey[500], fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    final isSelected = _selectedSkills.contains(skill);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedSkills.remove(skill);
          } else {
            _selectedSkills.add(skill);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _gold.withOpacity(0.1) : _cardDark,
          border: Border.all(color: isSelected ? _gold : Colors.transparent, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              skill,
              style: TextStyle(
                color: isSelected ? _gold : _textGrey,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Icon(Icons.check, color: _gold, size: 16),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioGrid() {
    // Placeholder image URLs for the grid
    final List<String> imageUrls = [
      'https://images.unsplash.com/photo-1506929562872-bb421503ef21?auto=format&fit=crop&q=80&w=300', // Beach
      'https://images.unsplash.com/photo-1593640408182-31c70c8268f5?auto=format&fit=crop&q=80&w=300', // Desk setup
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=300', // Man in suit
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1, // Square boxes
      ),
      itemCount: 4, // 3 images + 1 add button
      itemBuilder: (context, index) {
        if (index == 1) {
          // Add Button (Index 1 so it appears on the top left in RTL grid)
          return Container(
            decoration: BoxDecoration(
              color: _cardDark,
              borderRadius: BorderRadius.circular(12),
              // Using a standard border to simulate the dashed look without external packages
              border: Border.all(color: Colors.grey[800]!, width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_photo_alternate_outlined, color: Colors.white, size: 32),
                const SizedBox(height: 8),
                Text('إضافة عمل', style: TextStyle(color: _textGrey, fontSize: 12)),
              ],
            ),
          );
        }

        // Adjust index to pull the correct image from the list
        int imageIndex = index > 1 ? index - 1 : index;

        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imageUrls[imageIndex],
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        );
      },
    );
  }
}