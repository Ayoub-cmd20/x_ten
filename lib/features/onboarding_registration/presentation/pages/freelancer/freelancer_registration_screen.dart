import 'package:flutter/material.dart';
import 'package:x_ten/features/onboarding_registration/presentation/pages/registration_success_screen.dart';

class FreelancerRegistrationScreen extends StatefulWidget {
  const FreelancerRegistrationScreen({super.key});

  @override
  State<FreelancerRegistrationScreen> createState() =>
      _FreelancerRegistrationScreenState();
}

class _FreelancerRegistrationScreenState
    extends State<FreelancerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _experienceController = TextEditingController();
  final _rateController = TextEditingController();
  final _bioController = TextEditingController();
  final _portfolioController = TextEditingController();

  static const Color _goldColor = Color(0xFFE5C158);
  static const Color _bgDark = Color(0xFF0A0A0A);
  static const Color _cardDark = Color(0xFF181818);

  final List<String> _availableSkills = [
    'تصميم الجرافيك',
    'تطوير التطبيقات',
    'المونتاج وتحرير الفيديو',
    'كتابة المحتوى',
    'التسويق الرقمي',
    'التعليق الصوتي',
    'تصميم (UI/UX)',
    'التصوير الفوتوغرافي',
    'إدارة التواصل الاجتماعي',
    'الترجمة والتدقيق',
  ];

  final Set<String> _selectedSkills = {'تصميم الجرافيك', 'المونتاج وتحرير الفيديو'};

  @override
  void dispose() {
    _fullNameController.dispose();
    _jobTitleController.dispose();
    _experienceController.dispose();
    _rateController.dispose();
    _bioController.dispose();
    _portfolioController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RegistrationSuccessScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _bgDark,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward, color: _goldColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'تسجيل حساب مستقل',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Step Progress
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'بيانات المستقل والمهارات',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    Text(
                      'الخطوة 1 من 1',
                      style: TextStyle(color: _goldColor, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    value: 1.0,
                    backgroundColor: Color(0xFF222222),
                    valueColor: AlwaysStoppedAnimation<Color>(_goldColor),
                    minHeight: 4,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Form Scroll Area
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Avatar Placeholder
                        Center(
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              Container(
                                width: 95,
                                height: 95,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _cardDark,
                                  border: Border.all(color: _goldColor.withValues(alpha: 0.5), width: 1.5),
                                ),
                                child: const Icon(
                                  Icons.person_outline,
                                  color: Colors.grey,
                                  size: 44,
                                ),
                              ),
                              Positioned(
                                bottom: 2,
                                left: 2,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    color: _goldColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Section 1: Basic Info
                        _buildSectionHeader('المعلومات الشخصية والمهنية'),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _fullNameController,
                          label: 'الاسم الكامل',
                          hint: 'أدخل اسمك الكامل',
                          icon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'يرجى إدخال الاسم الكامل';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _jobTitleController,
                          label: 'المسمى الوظيفي / التخصص',
                          hint: 'مثال: مصمم واجهات، مطور Flutter، مخرج كليبات',
                          icon: Icons.work_outline,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'يرجى إدخال المسمى الوظيفي';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _experienceController,
                                label: 'سنوات الخبرة',
                                hint: 'مثال: 3 سنوات',
                                icon: Icons.history_edu,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                controller: _rateController,
                                label: 'سعر الخدمة / الساعة (دج)',
                                hint: 'مثال: 3000',
                                icon: Icons.payments_outlined,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _bioController,
                          label: 'نبذة عن خدماتك وخبراتك',
                          hint: 'اكتب وصفاً مختصراً يبرز مهاراتك وأبرز مشاريعك...',
                          icon: Icons.description_outlined,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 28),

                        // Section 2: Skills
                        _buildSectionHeader('المهارات والخدمات المقدمة'),
                        const SizedBox(height: 8),
                        Text(
                          'اختر المهارات التي تتقنها لتلقي الطلبات المناسبة:',
                          style: TextStyle(color: Colors.grey[400], fontSize: 13),
                        ),
                        const SizedBox(height: 12),

                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: _availableSkills.map((skill) {
                            final isSelected = _selectedSkills.contains(skill);
                            return FilterChip(
                              label: Text(skill),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedSkills.add(skill);
                                  } else {
                                    _selectedSkills.remove(skill);
                                  }
                                });
                              },
                              selectedColor: _goldColor,
                              backgroundColor: _cardDark,
                              checkmarkColor: Colors.black,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.black : Colors.white,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                fontSize: 13,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected ? _goldColor : const Color(0xFF2A2A2A),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 28),

                        // Section 3: Portfolio Link
                        _buildSectionHeader('معرض الأعمال والروابط'),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _portfolioController,
                          label: 'رابط معرض الأعمال (Portfolio / Behance / GitHub)',
                          hint: 'https://...',
                          icon: Icons.link,
                          keyboardType: TextInputType.url,
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Sticky Primary Button
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _goldColor,
                      foregroundColor: const Color(0xFF0A0A0A),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'إتمام التسجيل',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A0A0A),
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_back, // Points left in RTL
                          size: 18,
                          color: Color(0xFF0A0A0A),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[300],
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
            prefixIcon: Icon(icon, color: _goldColor, size: 20),
            filled: true,
            fillColor: _cardDark,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF262626)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _goldColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
