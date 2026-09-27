import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/models/influencer_registration_draft.dart';

class PersonalInfoStep extends StatefulWidget {
  final InfluencerRegistrationDraft draft;
  final VoidCallback onChanged;

  const PersonalInfoStep({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  @override
  State<PersonalInfoStep> createState() =>
      _PersonalInfoStepState();
}

class _PersonalInfoStepState extends State<PersonalInfoStep> {
  static const Color gold = Color(0xFFE5C158);
  static const Color surface = Color(0xFF161616);

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickProfileImage() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (file == null) return;

    setState(() {
      widget.draft.profileImagePath = file.path;
    });

    widget.onChanged();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate:
      widget.draft.birthDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime(
        now.year - 13,
        now.month,
        now.day,
      ),
    );

    if (date == null) return;

    setState(() {
      widget.draft.birthDate = date;
    });

    widget.onChanged();
  }

  InputDecoration _decoration({
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Colors.white54),
      hintStyle: const TextStyle(color: Colors.white24),
      prefixIcon: Icon(icon, color: gold),
      filled: true,
      fillColor: surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: gold,
          width: 1.2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = widget.draft.profileImagePath;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'المعلومات الشخصية',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'أدخل معلوماتك الأساسية كما تظهر في الوثائق الرسمية.',
          style: TextStyle(
            color: Colors.white54,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 24),

        Center(
          child: GestureDetector(
            onTap: _pickProfileImage,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 58,
                  backgroundColor: surface,
                  backgroundImage:
                  imagePath != null && imagePath.isNotEmpty
                      ? FileImage(File(imagePath))
                      : null,
                  child: imagePath == null || imagePath.isEmpty
                      ? const Icon(
                    Icons.person_outline_rounded,
                    color: gold,
                    size: 50,
                  )
                      : null,
                ),
                PositionedDirectional(
                  end: -2,
                  bottom: 2,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: gold,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        TextButton(
          onPressed: _pickProfileImage,
          child: const Text(
            'اختيار صورة البروفايل',
            style: TextStyle(color: gold),
          ),
        ),

        const SizedBox(height: 14),

        TextFormField(
          initialValue: widget.draft.firstName,
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            widget.draft.firstName = value;
            widget.onChanged();
          },
          decoration: _decoration(
            label: 'الاسم',
            icon: Icons.person_outline,
          ),
        ),

        const SizedBox(height: 12),

        TextFormField(
          initialValue: widget.draft.lastName,
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            widget.draft.lastName = value;
            widget.onChanged();
          },
          decoration: _decoration(
            label: 'اللقب',
            icon: Icons.badge_outlined,
          ),
        ),

        const SizedBox(height: 12),

        TextFormField(
          initialValue: widget.draft.displayName,
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            widget.draft.displayName = value;
            widget.onChanged();
          },
          decoration: _decoration(
            label: 'اسم الشهرة / البروفايل',
            icon: Icons.alternate_email_rounded,
          ),
        ),

        const SizedBox(height: 12),

        InkWell(
          onTap: _pickBirthDate,
          borderRadius: BorderRadius.circular(15),
          child: InputDecorator(
            decoration: _decoration(
              label: 'تاريخ الميلاد',
              icon: Icons.calendar_month_outlined,
            ),
            child: Text(
              widget.draft.birthDate == null
                  ? 'اختر تاريخ الميلاد'
                  : '${widget.draft.birthDate!.day.toString().padLeft(2, '0')}/'
                  '${widget.draft.birthDate!.month.toString().padLeft(2, '0')}/'
                  '${widget.draft.birthDate!.year}',
              style: TextStyle(
                color: widget.draft.birthDate == null
                    ? Colors.white38
                    : Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        TextFormField(
          initialValue: widget.draft.birthPlace,
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            widget.draft.birthPlace = value;
            widget.onChanged();
          },
          decoration: _decoration(
            label: 'مكان الميلاد',
            icon: Icons.location_on_outlined,
          ),
        ),

        const SizedBox(height: 12),

        TextFormField(
          initialValue: widget.draft.bio,
          minLines: 4,
          maxLines: 6,
          style: const TextStyle(
            color: Colors.white,
            height: 1.5,
          ),
          onChanged: (value) {
            widget.draft.bio = value;
            widget.onChanged();
          },
          decoration: _decoration(
            label: 'نبذة عن المؤثر',
            icon: Icons.description_outlined,
            hint: 'عرّف بنفسك وبنوع المحتوى الذي تقدمه...',
          ),
        ),

        const SizedBox(height: 12),

        TextFormField(
          initialValue: widget.draft.skills,
          minLines: 3,
          maxLines: 5,
          style: const TextStyle(
            color: Colors.white,
            height: 1.5,
          ),
          onChanged: (value) {
            widget.draft.skills = value;
            widget.onChanged();
          },
          decoration: _decoration(
            label: 'المهارات والإمكانيات',
            icon: Icons.workspace_premium_outlined,
            hint: 'مثال: تصوير، مونتاج، تقديم، كتابة محتوى...',
          ),
        ),
      ],
    );
  }
}