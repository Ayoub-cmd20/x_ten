import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:x_ten/features/onboarding_registration/presentation/pages/company/company_contact_screen.dart';

class CompanyOfficialInfoScreen extends StatefulWidget {
  const CompanyOfficialInfoScreen({super.key});

  @override
  State<CompanyOfficialInfoScreen> createState() =>
      _CompanyOfficialInfoScreenState();
}

class _CompanyOfficialInfoScreenState extends State<CompanyOfficialInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final _commercialRegController = TextEditingController();
  final _foundationDateController = TextEditingController();
  final _nisController = TextEditingController();
  final _nifController = TextEditingController();
  final _ribController = TextEditingController();

  bool _isRibValid = true;

  @override
  void dispose() {
    _commercialRegController.dispose();
    _foundationDateController.dispose();
    _nisController.dispose();
    _nifController.dispose();
    _ribController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFD4A843),
              onPrimary: Colors.black,
              surface: Color(0xFF2A2A2A),
              onSurface: Colors.white,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Color(0xFF1A1A1A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        final month = picked.month.toString().padLeft(2, '0');
        final day = picked.day.toString().padLeft(2, '0');
        final year = picked.year.toString();
        _foundationDateController.text = '$month/$day/$year';
      });
    }
  }

  void _validateRib(String value) {
    setState(() {
      _isRibValid = value.length >= 20;
    });
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
                  children: const [
                    Text(
                      'البيانات الرسمية والمالية',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'الخطوة 2 من 5',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.4,
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
                  children: [
                    const Text(
                      'البيانات الرسمية والمالية',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'يرجى إدخال تفاصيل التسجيل التجاري و المعلومات المصرفية لشركتك بدقة.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
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
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF252525),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFD4A843).withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Commercial Register Number
                          _buildTextField(
                            label: 'رقم السجل التجاري',
                            hint: 'مثال: 123456789',
                            controller: _commercialRegController,
                            keyboardType: TextInputType.number,
                          ),

                          const SizedBox(height: 16),

                          // Foundation Date
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'تاريخ التأسيس',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _foundationDateController,
                                readOnly: true,
                                onTap: _pickDate,
                                style: const TextStyle(color: Colors.white),
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                  hintText: 'm/dd/yyyy',
                                  hintStyle: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.35),
                                    fontSize: 14,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.calendar_today_outlined,
                                    color: Colors.white54,
                                    size: 22,
                                  ),
                                  suffixIcon: const Icon(
                                    Icons.calendar_month_outlined,
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
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'هذا الحقل مطلوب';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // NIS Number
                          _buildTextField(
                            label: 'الرقم التعريفي الإحصائي (NIS)',
                            hint: 'أدخل رقم NIS',
                            controller: _nisController,
                            keyboardType: TextInputType.number,
                          ),

                          const SizedBox(height: 16),

                          // NIF Number
                          _buildTextField(
                            label: 'الرقم التعريفي الجبائي (NIF)',
                            hint: 'أدخل رقم NIF',
                            controller: _nifController,
                            keyboardType: TextInputType.number,
                          ),

                          const SizedBox(height: 16),

                          // RIB / IBAN
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'رقم الحساب البنكي (RIB/IBAN)',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _ribController,
                                onChanged: _validateRib,
                                style: const TextStyle(color: Colors.white),
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: 'DZ45 1234 5678 9012 3456',
                                  hintStyle: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.35),
                                    fontSize: 14,
                                  ),
                                  suffixIcon: _isRibValid
                                      ? const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Color(0xFF4ADE80),
                                      size: 24,
                                    ),
                                  )
                                      : null,
                                  filled: true,
                                  fillColor: const Color(0xFF1E1E1E),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: _isRibValid
                                          ? const Color(0xFF4ADE80)
                                          .withValues(alpha: 0.5)
                                          : const Color(0xFF3A3A3A),
                                      width: 1.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: _isRibValid
                                          ? const Color(0xFF4ADE80)
                                          .withValues(alpha: 0.5)
                                          : const Color(0xFF3A3A3A),
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: _isRibValid
                                          ? const Color(0xFF4ADE80)
                                          : const Color(0xFFD4A843),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'هذا الحقل مطلوب';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 8),
                              if (_isRibValid)
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.verified_user_outlined,
                                      color: Color(0xFF4ADE80),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'رقم حساب صحيح',
                                      style: TextStyle(
                                        color: const Color(0xFF4ADE80)
                                            .withValues(alpha: 0.9),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
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
                      flex: 3,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CompanyContactScreen(),
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
                            Icon(Icons.arrow_forward_ios, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'Next Step',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
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
                            Text(
                              'Back',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 16,
                            ),
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
    TextInputType keyboardType = TextInputType.text,
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
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.35),
              fontSize: 14,
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
            if (value == null || value.trim().isEmpty) {
              return 'هذا الحقل مطلوب';
            }
            return null;
          },
        ),
      ],
    );
  }
}