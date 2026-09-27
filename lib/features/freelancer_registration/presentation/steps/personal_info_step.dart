import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/models/freelancer_registration_draft.dart';

class PersonalInfoStep extends StatefulWidget {
  final FreelancerRegistrationDraft draft;
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

class _PersonalInfoStepState
    extends State<PersonalInfoStep> {
  static const Color gold = Color(0xFFE5C158);

  InputDecoration _decoration(
      String label,
      IconData icon,
      ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        icon,
        color: gold,
      ),
      filled: true,
      fillColor: const Color(0xFF161616),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedImage =
    await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedImage != null) {
      setState(() {
        widget.draft.profileImagePath =
            pickedImage.path;
      });

      widget.onChanged();
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final selectedDate =
    await showDatePicker(
      context: context,
      initialDate:
      widget.draft.birthDate ??
          DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime(
        now.year - 18,
        now.month,
        now.day,
      ),
    );

    if (selectedDate != null) {
      setState(() {
        widget.draft.birthDate =
            selectedDate;
      });

      widget.onChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileImagePath =
        widget.draft.profileImagePath;

    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            radius: 56,
            backgroundColor:
            const Color(0xFF161616),
            backgroundImage:
            profileImagePath != null &&
                profileImagePath.isNotEmpty
                ? FileImage(
              File(
                profileImagePath,
              ),
            )
                : null,
            child:
            profileImagePath == null ||
                profileImagePath.isEmpty
                ? const Icon(
              Icons.add_a_photo_outlined,
              color: gold,
              size: 34,
            )
                : null,
          ),
        ),

        const SizedBox(
          height: 18,
        ),

        TextFormField(
          initialValue:
          widget.draft.firstName,
          style: const TextStyle(
            color: Colors.white,
          ),
          onChanged: (value) {
            widget.draft.firstName =
                value;
          },
          decoration: _decoration(
            'الاسم',
            Icons.person_outline,
          ),
        ),

        const SizedBox(
          height: 12,
        ),

        TextFormField(
          initialValue:
          widget.draft.lastName,
          style: const TextStyle(
            color: Colors.white,
          ),
          onChanged: (value) {
            widget.draft.lastName =
                value;
          },
          decoration: _decoration(
            'اللقب',
            Icons.badge_outlined,
          ),
        ),

        const SizedBox(
          height: 12,
        ),

        TextFormField(
          initialValue:
          widget.draft.displayName,
          style: const TextStyle(
            color: Colors.white,
          ),
          onChanged: (value) {
            widget.draft.displayName =
                value;
          },
          decoration: _decoration(
            'اسم العرض',
            Icons.alternate_email,
          ),
        ),

        const SizedBox(
          height: 12,
        ),

        InkWell(
          onTap: _pickDate,
          child: InputDecorator(
            decoration: _decoration(
              'تاريخ الميلاد',
              Icons.calendar_month_outlined,
            ),
            child: Text(
              widget.draft.birthDate == null
                  ? 'اختر التاريخ'
                  : '${widget.draft.birthDate!.day}/'
                  '${widget.draft.birthDate!.month}/'
                  '${widget.draft.birthDate!.year}',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(
          height: 12,
        ),

        TextFormField(
          initialValue:
          widget.draft.birthPlace,
          style: const TextStyle(
            color: Colors.white,
          ),
          onChanged: (value) {
            widget.draft.birthPlace =
                value;
          },
          decoration: _decoration(
            'مكان الميلاد',
            Icons.location_on_outlined,
          ),
        ),

        const SizedBox(
          height: 12,
        ),

        TextFormField(
          initialValue:
          widget.draft.bio,
          minLines: 4,
          maxLines: 6,
          style: const TextStyle(
            color: Colors.white,
          ),
          onChanged: (value) {
            widget.draft.bio =
                value;
          },
          decoration: _decoration(
            'نبذة شخصية',
            Icons.description_outlined,
          ),
        ),
      ],
    );
  }
}