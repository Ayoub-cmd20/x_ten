import 'package:flutter/material.dart';
import 'registration_success_screen.dart';

class FinancialSecurityScreen extends StatefulWidget {
  const FinancialSecurityScreen({super.key});

  @override
  State<FinancialSecurityScreen> createState() => _FinancialSecurityScreenState();
}

class _FinancialSecurityScreenState extends State<FinancialSecurityScreen> {
  // Theme Colors
  final Color _bgDark = const Color(0xFF101010);
  final Color _cardDark = const Color(0xFF1A1A1A);
  final Color _inputDark = const Color(0xFF0A0A0A);
  final Color _gold = const Color(0xFFE2C044);
  final Color _textGrey = const Color(0xFFA0A0A0);

  // Checkbox States
  bool _agreeToDataPolicy = false;
  bool _agreeToTerms = false;

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
            'البيانات المالية والأمنية',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'OBSIDIAN',
                  style: TextStyle(
                    color: _gold,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // 1. Top Progress Bar (Fully complete)
            Row(
              children: [
                Expanded(flex: 10, child: Container(height: 3, color: _gold)),
              ],
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- SECTION 1: Financial Institutions ---
                    _buildSectionHeader('المؤسسات المالية', Icons.account_balance),
                    const SizedBox(height: 16),
                    _buildCustomInputField(
                      label: 'اسم البنك / المؤسسة',
                      hint: 'مثال: مصرف الراجحي',
                    ),
                    const SizedBox(height: 16),
                    _buildCustomInputField(
                      label: 'رقم الآيبان (IBAN)',
                      hint: 'SA00 0000 0000 0000 0000 0000',
                    ),
                    const SizedBox(height: 32),

                    // --- SECTION 2: Security Settings ---
                    _buildSectionHeader('إعدادات الأمان', Icons.security),
                    const SizedBox(height: 16),
                    _buildCustomInputField(
                      label: 'اسم المستخدم أو البريد الإلكتروني',
                      hint: 'influencer@vault.com',
                      icon: Icons.alternate_email,
                    ),
                    const SizedBox(height: 16),
                    _buildCustomInputField(
                      label: 'كلمة المرور',
                      hint: '********',
                      isPassword: true,
                    ),
                    const SizedBox(height: 16),
                    _buildCustomInputField(
                      label: 'تأكيد كلمة المرور',
                      hint: '********',
                      isPassword: true,
                    ),
                    const SizedBox(height: 16),
                    _buildCustomInputField(
                      label: 'طريقة الاسترداد',
                      hint: 'رقم الهاتف',
                    ),
                    const SizedBox(height: 32),

                    // --- SECTION 3: Official Documents ---
                    _buildSectionHeader('رفع المستندات الرسمية', Icons.cloud_upload),
                    const SizedBox(height: 16),
                    _buildUploadCard(
                      title: 'بطاقة التعريف',
                      subtitle: 'صورة واضحة للوجهين (JPG, PNG)',
                      icon: Icons.badge_outlined,
                      bgImageUrl: 'https://images.unsplash.com/photo-1634224143538-ce0221abf732?auto=format&fit=crop&q=80&w=400', // Abstract card texture
                    ),
                    const SizedBox(height: 16),
                    _buildUploadCard(
                      title: 'صكوك وشيكات',
                      subtitle: 'نسخة من شيك بنكي أو كشف حساب',
                      icon: Icons.request_quote_outlined,
                      bgImageUrl: 'https://images.unsplash.com/photo-1628156321287-19062eb295cb?auto=format&fit=crop&q=80&w=400', // Abstract document texture
                    ),
                    const SizedBox(height: 32),

                    // --- SECTION 4: Terms & Conditions Checkboxes ---
                    _buildCustomCheckbox(
                      value: _agreeToDataPolicy,
                      onChanged: (val) => setState(() => _agreeToDataPolicy = val!),
                      textSpans: [
                        const TextSpan(text: 'أوافق على سياسة '),
                        TextSpan(text: 'حماية البيانات', style: TextStyle(color: _gold, fontWeight: FontWeight.bold)),
                        const TextSpan(text: ' والمعالجة\nالآمنة للمعلومات الحساسة.'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildCustomCheckbox(
                      value: _agreeToTerms,
                      onChanged: (val) => setState(() => _agreeToTerms = val!),
                      textSpans: [
                        const TextSpan(text: 'أؤكد اطلاعي وموافقتي على '),
                        TextSpan(text: 'الشروط والأحكام', style: TextStyle(color: _gold, fontWeight: FontWeight.bold)),
                        const TextSpan(text: '\nالخاصة بنظام النخبة.'),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // --- SUBMIT BUTTON ---
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // 1. Perform your form validation and API submission logic here

                          // 2. Navigate to Success screen and clear the navigation stack
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const RegistrationSuccessScreen()),
                                (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _gold,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'إرسال الطلب',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  // Section Header
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: _gold, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Custom Input Field (Label inside the dark container)
  Widget _buildCustomInputField({
    required String label,
    required String hint,
    IconData? icon,
    bool isPassword = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: _textGrey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: _inputDark,
              borderRadius: BorderRadius.circular(6),
            ),
            child: TextField(
              obscureText: isPassword,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey[700], fontSize: 13),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                // Left-side icon in RTL layout
                suffixIcon: icon != null ? Icon(icon, color: Colors.grey[600], size: 20) : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom Upload Document Card
  Widget _buildUploadCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String bgImageUrl,
  }) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: _cardDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[900]!),
        image: DecorationImage(
          image: NetworkImage(bgImageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.85), // Darken the image heavily
            BlendMode.darken,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: _gold, size: 28),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: _textGrey, fontSize: 10),
                ),
              ],
            ),
          ),
          // Action Button on the left (in RTL)
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _gold.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_add_alt_1, color: _gold, size: 18), // Closest match to the person/upload icon
            ),
          ),
        ],
      ),
    );
  }

  // Custom Checkbox Row
  Widget _buildCustomCheckbox({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required List<TextSpan> textSpans,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox Box
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: value ? _gold : Colors.transparent,
              border: Border.all(color: value ? _gold : Colors.grey[700]!, width: 1.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: value
                ? const Icon(Icons.check, size: 16, color: Colors.black)
                : null,
          ),
          const SizedBox(width: 12),
          // Rich Text
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: _textGrey, fontSize: 12, height: 1.5, fontFamily: 'Cairo'),
                children: textSpans,
              ),
            ),
          ),
        ],
      ),
    );
  }
}