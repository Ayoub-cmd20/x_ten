import 'package:flutter/material.dart';
import 'sectors_selection_screen.dart';

class LanguageRegistrationScreen extends StatefulWidget {
  const LanguageRegistrationScreen({super.key});

  @override
  State<LanguageRegistrationScreen> createState() => _LanguageRegistrationScreenState();
}

class _LanguageRegistrationScreenState extends State<LanguageRegistrationScreen> {
  final Color _bgDark = const Color(0xFF101010);
  final Color _cardDark = const Color(0xFF1A1A1A);
  final Color _gold = const Color(0xFFE2C044);
  final Color _textGrey = const Color(0xFFA0A0A0);

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
            icon: const Icon(Icons.arrow_forward, color: Color(0xFFE2C044)), // Back button in RTL
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
                Expanded(
                  flex: 7,
                  child: Container(height: 3, color: _gold),
                ),
                Expanded(
                  flex: 3,
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
                    // 2. Header Title & Subtitle
                    Text(
                      'نظام اللغات',
                      style: TextStyle(
                        color: _gold,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'حدد اللغات التي تتقنها ومستوى مهارتك فيها.',
                      style: TextStyle(
                        color: _textGrey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // 3. Arabic Card
                    _buildLanguageCard(
                      title: 'العربية',
                      icon: Icons.language,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('المستوى'),
                          Row(
                            children: [
                              Expanded(child: _buildLevelOption('متقدم', isSelected: true)),
                              const SizedBox(width: 8),
                              Expanded(child: _buildLevelOption('جيد', isSelected: false)),
                              const SizedBox(width: 8),
                              Expanded(child: _buildLevelOption('أساسي', isSelected: false)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildLabel('الاستخدام'),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildUsageOption('فهم', isSelected: true, showCheck: true),
                              _buildUsageOption('تحدث', isSelected: true, showCheck: true),
                              _buildUsageOption('تقديم عروض', isSelected: true, showCheck: true),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 4. French Card
                    _buildLanguageCard(
                      title: 'الفرنسية',
                      icon: Icons.translate,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('المستوى'),
                          Row(
                            children: [
                              Expanded(child: _buildLevelOption('متقدم', isSelected: false)),
                              const SizedBox(width: 8),
                              Expanded(child: _buildLevelOption('جيد', isSelected: true)),
                              const SizedBox(width: 8),
                              Expanded(child: _buildLevelOption('أساسي', isSelected: false)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildLabel('الاستخدام'),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildUsageOption('فهم', isSelected: true, showCheck: false),
                              _buildUsageOption('تحدث', isSelected: false, showCheck: false),
                              _buildUsageOption('تقديم عروض', isSelected: false, showCheck: false),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 5. English Card (Slider version)
                    _buildLanguageCard(
                      title: 'الإنجليزية',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('مستوى الإتقان'),
                          const SizedBox(height: 8),
                          // Custom Slider Area
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 4,
                                width: double.infinity,
                                color: Colors.grey[800],
                              ),
                              Positioned(
                                right: 0,
                                child: Container(
                                  height: 4,
                                  width: MediaQuery.of(context).size.width * 0.4, // Adjust for 'Very Good'
                                  color: _gold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('أساسي', style: TextStyle(color: _textGrey, fontSize: 12)),
                              Text('جيد جداً', style: TextStyle(color: _gold, fontSize: 12, fontWeight: FontWeight.bold)),
                              Text('متقدم', style: TextStyle(color: _textGrey, fontSize: 12)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildLabel('مهام الاستخدام'),
                          Row(
                            children: [
                              _buildUsageOption('فهم', isSelected: true, icon: Icons.hearing),
                              const SizedBox(width: 8),
                              _buildUsageOption('تحدث', isSelected: false, icon: Icons.mic_none),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 6. Algerian Darja Card (Native)
                    _buildLanguageCard(
                      title: 'الدارجة الجزائرية',
                      isNative: true,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF121212),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('المستوى الحالي', style: TextStyle(color: _textGrey, fontSize: 12)),
                                Text('طلاقة تامة', style: TextStyle(color: _gold, fontSize: 14, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _buildUsageOption('فهم', isSelected: false),
                              const SizedBox(width: 8),
                              _buildUsageOption('تحدث', isSelected: false),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 7. Amazigh Card (Add Skills)
                    _buildLanguageCard(
                      title: 'الأمازيغية',
                      icon: Icons.edit_outlined,
                      content: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[700]!, width: 1, style: BorderStyle.solid), // Using solid as fallback. For dashed, use `dotted_border` package
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            '+ تحديد المهارات',
                            style: TextStyle(color: _textGrey, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // 8. Divider with Star
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey[800], thickness: 1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Icon(Icons.star_border, color: Colors.grey[700], size: 20),
                        ),
                        Expanded(child: Divider(color: Colors.grey[800], thickness: 1)),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // 9. Bottom Navigation Buttons
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
                  // Continue Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SectorsSelectionScreen()),
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

  // --- Helper Widgets ---

  Widget _buildLanguageCard({required String title, IconData? icon, bool isNative = false, required Widget content}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (isNative) ...[
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _gold,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'NATIVE',
                        style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]
                ],
              ),
              if (icon != null) Icon(icon, color: Colors.grey[600], size: 22),
            ],
          ),
          const SizedBox(height: 24),
          content,
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: TextStyle(color: _textGrey, fontSize: 12),
      ),
    );
  }

  Widget _buildLevelOption(String text, {required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: isSelected ? _gold : Colors.grey[800]!),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? _gold : Colors.grey[500],
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildUsageOption(String text, {required bool isSelected, bool showCheck = false, IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: isSelected ? _gold : Colors.grey[800]!),
        borderRadius: BorderRadius.circular(20), // Pill shape
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: isSelected ? _gold : Colors.grey[500]),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: TextStyle(
              color: isSelected ? _gold : Colors.grey[500],
              fontSize: 13,
            ),
          ),
          if (showCheck && isSelected) ...[
            const SizedBox(width: 6),
            Icon(Icons.check_circle, size: 14, color: _gold),
          ],
        ],
      ),
    );
  }
}