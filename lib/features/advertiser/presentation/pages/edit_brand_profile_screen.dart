import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Screen for editing the advertiser's brand profile information.
class EditBrandProfileScreen extends StatefulWidget {
  final String initialBrandName;
  final String initialEmail;
  final String initialCategory;
  final String initialPhone;
  final String initialBio;
  final String initialWebsite;
  final String initialLocation;

  const EditBrandProfileScreen({
    super.key,
    this.initialBrandName = 'اسم العلامة التجارية',
    this.initialEmail = 'brand@example.com',
    this.initialCategory = 'التجارة الإلكترونية',
    this.initialPhone = '+966 50 123 4567',
    this.initialBio = 'علامة تجارية متخصصة في تقديم أحدث المنتجات والتجارب المبتكرة.',
    this.initialWebsite = 'https://brand.example.com',
    this.initialLocation = 'الرياض، المملكة العربية السعودية',
  });

  @override
  State<EditBrandProfileScreen> createState() => _EditBrandProfileScreenState();
}

class _EditBrandProfileScreenState extends State<EditBrandProfileScreen> {
  static const Color _gold = Color(0xFFE5C158);
  static const Color _background = Color(0xFF0A0A0A);
  static const Color _surface = Color(0xFF151515);
  static const Color _fieldBg = Color(0xFF1A1A1A);

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _brandNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _bioController;
  late final TextEditingController _websiteController;
  late final TextEditingController _locationController;

  late String _selectedCategory;

  final List<String> _categories = [
    'التجارة الإلكترونية',
    'التكنولوجيا والبرمجيات',
    'الأزياء والموضة',
    'الأغذية والمشروبات',
    'الصحة والجمال',
    'الخدمات المالية والاستثمار',
    'السياحة والسفر',
    'أخرى',
  ];

  @override
  void initState() {
    super.initState();
    _brandNameController = TextEditingController(text: widget.initialBrandName);
    _emailController = TextEditingController(text: widget.initialEmail);
    _phoneController = TextEditingController(text: widget.initialPhone);
    _bioController = TextEditingController(text: widget.initialBio);
    _websiteController = TextEditingController(text: widget.initialWebsite);
    _locationController = TextEditingController(text: widget.initialLocation);

    _selectedCategory = _categories.contains(widget.initialCategory)
        ? widget.initialCategory
        : _categories.first;
  }

  @override
  void dispose() {
    _brandNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _websiteController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedData = {
        'brandName': _brandNameController.text.trim(),
        'email': _emailController.text.trim(),
        'category': _selectedCategory,
        'phone': _phoneController.text.trim(),
        'bio': _bioController.text.trim(),
        'website': _websiteController.text.trim(),
        'location': _locationController.text.trim(),
      };

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.black),
              SizedBox(width: 10),
              Text(
                'تم حفظ بيانات العلامة التجارية بنجاح',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          backgroundColor: _gold,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      context.pop(updatedData);
    }
  }

  void _showAvatarChangeOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'تغيير شعار العلامة التجارية',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined, color: _gold),
                  title: const Text('اختيار من المعرض', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم اختيار صورة جديدة لشعار العلامة التجارية'),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined, color: _gold),
                  title: const Text('التقاط صورة جديدة', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم التقاط صورة جديدة لشعار العلامة التجارية'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _background,
        appBar: AppBar(
          backgroundColor: _background,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'تعديل ملف العلامة التجارية',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => context.pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --------------------------------------------------
                // BRAND LOGO UPLOADER
                // --------------------------------------------------
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: _gold.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _gold.withValues(alpha: 0.4),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.storefront_outlined,
                          color: _gold,
                          size: 44,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: InkWell(
                          onTap: _showAvatarChangeOptions,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: _gold,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.black,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: _showAvatarChangeOptions,
                    child: const Text(
                      'تغيير شعار الشركة / العلامة التجارية',
                      style: TextStyle(
                        color: _gold,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // --------------------------------------------------
                // SECTION: BASIC BRAND INFORMATION
                // --------------------------------------------------
                _buildSectionHeader('المعلومات الأساسية'),
                const SizedBox(height: 14),

                _buildTextField(
                  controller: _brandNameController,
                  label: 'اسم العلامة التجارية',
                  hint: 'أدخل اسم العلامة التجارية',
                  icon: Icons.business_rounded,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'يرجى إدخال اسم العلامة التجارية';
                    }
                    return null;
                  },
                ),

                _buildTextField(
                  controller: _emailController,
                  label: 'البريد الإلكتروني للعمل',
                  hint: 'brand@example.com',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'يرجى إدخال البريد الإلكتروني';
                    }
                    if (!value.contains('@')) {
                      return 'يرجى إدخال بريد إلكتروني صحيح';
                    }
                    return null;
                  },
                ),

                // Category Dropdown
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'مجال النشاط التجاري',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        dropdownColor: _surface,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: _fieldBg,
                          prefixIcon: const Icon(Icons.category_outlined, color: _gold, size: 20),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: _gold, width: 1.5),
                          ),
                        ),
                        items: _categories.map((cat) {
                          return DropdownMenuItem<String>(
                            value: cat,
                            child: Text(cat),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedCategory = val);
                          }
                        },
                      ),
                    ],
                  ),
                ),

                _buildTextField(
                  controller: _bioController,
                  label: 'نبذة عن العلامة التجارية',
                  hint: 'اكتب وصفاً قصيراً يعرّف بعلامتك التجارية...',
                  icon: Icons.description_outlined,
                  maxLines: 3,
                ),

                const SizedBox(height: 12),

                // --------------------------------------------------
                // SECTION: CONTACT & LOCATION
                // --------------------------------------------------
                _buildSectionHeader('التواصل والموقع'),
                const SizedBox(height: 14),

                _buildTextField(
                  controller: _phoneController,
                  label: 'رقم الهاتف / التواصل',
                  hint: '+966 50 000 0000',
                  icon: Icons.phone_android_rounded,
                  keyboardType: TextInputType.phone,
                ),

                _buildTextField(
                  controller: _websiteController,
                  label: 'الموقع الإلكتروني / المتجر',
                  hint: 'https://brand.com',
                  icon: Icons.language_rounded,
                  keyboardType: TextInputType.url,
                ),

                _buildTextField(
                  controller: _locationController,
                  label: 'المدينة والدولة',
                  hint: 'الرياض، المملكة العربية السعودية',
                  icon: Icons.location_on_outlined,
                ),

                const SizedBox(height: 28),

                // --------------------------------------------------
                // SAVE BUTTON
                // --------------------------------------------------
                Container(
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_gold, Color(0xFFC5A038)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: _gold.withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'حفظ التغييرات',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: _gold,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.white.withValues(alpha: 0.3),
                fontSize: 13.5,
              ),
              filled: true,
              fillColor: _fieldBg,
              prefixIcon: Icon(icon, color: _gold, size: 20),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: _gold, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.redAccent, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
