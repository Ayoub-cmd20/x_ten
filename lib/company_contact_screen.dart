import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'company_document_upload_screen.dart';

class CompanyContactScreen extends StatefulWidget {
  const CompanyContactScreen({super.key});

  @override
  State<CompanyContactScreen> createState() => _CompanyContactScreenState();
}

class _CompanyContactScreenState extends State<CompanyContactScreen> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();

  final List<Map<String, String>> _marketingLinks = [
    {
      'platform': 'LinkedIn',
      'url': 'linkedin.com/company/example',
      'icon': 'linkedin',
    },
    {
      'platform': 'Twitter',
      'url': '@examplecompany',
      'icon': 'twitter',
    },
  ];

  void _removeLink(int index) {
    setState(() {
      _marketingLinks.removeAt(index);
    });
  }

  void _showAddLinkDialog() {
    final platformController = TextEditingController();
    final urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: const Color(0xFF252525),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'إضافة رابط',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: platformController,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: 'اسم المنصة',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFD4A843)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: urlController,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: 'رابط الحساب',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFD4A843)),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (platformController.text.isNotEmpty &&
                      urlController.text.isNotEmpty) {
                    setState(() {
                      _marketingLinks.add({
                        'platform': platformController.text,
                        'url': urlController.text,
                        'icon': 'link',
                      });
                    });
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4A843),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('إضافة'),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getPlatformIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'linkedin':
        return Icons.business_center_outlined;
      case 'twitter':
        return Icons.chat_bubble_outline;
      default:
        return Icons.language;
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFFD4A843),
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Company\nRegistration',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Step info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'معلومات الاتصال',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const Text(
                      'الخطوة 3 من 5',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Progress bar (step 3 / 5 = 60%)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.6,
                    backgroundColor: const Color(0xFF2A2A2A),
                    valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xFFD4A843)),
                    minHeight: 6,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Title & Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'معلومات الاتصال',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'يرجى تقديم تفاصيل الاتصال الأساسية لعملك.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Phone Number
                        _buildTextField(
                          label: 'رقم الهاتف *',
                          hint: '+1 (555) 000-0000',
                          controller: _phoneController,
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),

                        const SizedBox(height: 16),

                        // Business Email
                        _buildTextField(
                          label: 'البريد الإلكتروني للعمل *',
                          hint: 'contact@company.com',
                          controller: _emailController,
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 16),

                        // Website (Optional)
                        _buildTextField(
                          label: 'الموقع الإلكتروني (اختياري)',
                          hint: 'https://www.yourcompany.com',
                          controller: _websiteController,
                          icon: Icons.language,
                          isOptional: true,
                        ),

                        const SizedBox(height: 24),

                        // Marketing Links Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF252525),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFD4A843).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              // Header
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.share_outlined,
                                        color: Color(0xFFD4A843),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'روابط التسويق',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: _showAddLinkDialog,
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.add,
                                          color: Color(0xFFD4A843),
                                          size: 18,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'إضافة رابط',
                                          style: TextStyle(
                                            color: const Color(0xFFD4A843)
                                                .withOpacity(0.9),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Links List
                              ..._marketingLinks.asMap().entries.map((entry) {
                                final index = entry.key;
                                final link = entry.value;
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E1E1E),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFF3A3A3A),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF2A2A2A),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          _getPlatformIcon(link['icon']!),
                                          color: Colors.white70,
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              link['platform']!,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              link['url']!,
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => _removeLink(index),
                                        child: Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF2A2A2A),
                                            borderRadius:
                                            BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white54,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Bottom Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Back',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CompanyDocumentUploadScreen(),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4A843),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Next Step',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_ios, size: 16),
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
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isOptional = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.35),
              fontSize: 14,
            ),
            prefixIcon: Icon(
              icon,
              color: Colors.white54,
              size: 22,
            ),
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF3A3A3A),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF3A3A3A),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFD4A843),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.redAccent,
                width: 1,
              ),
            ),
          ),
          validator: (value) {
            if (!isOptional && (value == null || value.trim().isEmpty)) {
              return 'هذا الحقل مطلوب';
            }
            if (!isOptional &&
                keyboardType == TextInputType.emailAddress &&
                value != null &&
                value.isNotEmpty &&
                !value.contains('@')) {
              return 'أدخل بريد إلكتروني صحيح';
            }
            return null;
          },
        ),
      ],
    );
  }
}