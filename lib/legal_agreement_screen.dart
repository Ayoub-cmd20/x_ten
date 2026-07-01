import 'package:flutter/material.dart';

class LegalAgreementPage extends StatefulWidget {
  const LegalAgreementPage({super.key});

  @override
  State<LegalAgreementPage> createState() => _LegalAgreementPageState();
}

class _LegalAgreementPageState extends State<LegalAgreementPage> {
  bool privacyAccepted = false;
  bool termsAccepted = false;

  static const Color primaryColor = Color(0xFFF6C443);
  static const Color backgroundColor = Color(0xFF0F0F10);
  static const Color cardColor = Color(0xFF1A1A1C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 16),

                    /// Title
                    Text(
                      "الجوانب القانونية\nوالخصوصية",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        height: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "نحن نلتزم بشفافية كاملة معك، يرجى مراجعة الشروط والأحكام وسياسة حماية البيانات للمتابعة.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        height: 1.6,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 28),

                    _buildPolicyCard(
                      icon: Icons.gavel_outlined,
                      title: "شروط الخدمة",
                      description:
                      "تحدد هذه الاتفاقية العلاقة التعاقدية بين المنصة ومقدمي الخدمات والعملاء، وتشمل الملكية الفكرية، شروط الدفع، ومعايير السلوك المهني.",
                    ),

                    const SizedBox(height: 18),

                    _buildPolicyCard(
                      icon: Icons.shield_outlined,
                      title: "سياسة حماية البيانات",
                      description:
                      "نلتزم بحماية بياناتك الشخصية وتفاصيل حسابك، واستخدامها فقط لتحسين تجربتك وضمان التعاون مع المعاملات التجارية.",
                    ),

                    const SizedBox(height: 24),

                    _buildCheckTile(
                      title:
                      "أوافق على سياسة حماية البيانات الشخصية ومعالجتها.",
                      value: privacyAccepted,
                      onChanged: (v) {
                        setState(() {
                          privacyAccepted = v!;
                        });
                      },
                    ),

                    const SizedBox(height: 14),

                    _buildCheckTile(
                      title:
                      "لقد قرأت وأوافق على شروط وأحكام منصة \"مقاول\".",
                      value: termsAccepted,
                      onChanged: (v) {
                        setState(() {
                          termsAccepted = v!;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 58),
                        side: BorderSide(
                          color: primaryColor.withOpacity(.3),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "السابق",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: privacyAccepted && termsAccepted
                          ? () {}
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.black,
                        disabledBackgroundColor: Colors.grey.shade700,
                        minimumSize: const Size(0, 58),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "متابعة",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPolicyCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: primaryColor.withOpacity(.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(
                icon,
                color: primaryColor,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Color(0xFFF6C443),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            description,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.7,
            ),
          ),

          const SizedBox(height: 18),

          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.open_in_new,
                size: 18,
                color: Color(0xFFF6C443),
              ),
              label: const Text(
                "عرض السياسة الكاملة",
                style: TextStyle(
                  color: Color(0xFFF6C443),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCheckTile({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        activeColor: primaryColor,
        checkColor: Colors.black,
        side: BorderSide(
          color: Colors.grey.shade600,
        ),
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          title,
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}