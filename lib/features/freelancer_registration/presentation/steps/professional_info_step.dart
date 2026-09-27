import 'package:flutter/material.dart';

import '../../domain/models/freelancer_registration_draft.dart';

class ProfessionalInfoStep extends StatefulWidget {
  final FreelancerRegistrationDraft draft;
  final VoidCallback onChanged;

  const ProfessionalInfoStep({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  @override
  State<ProfessionalInfoStep> createState() =>
      _ProfessionalInfoStepState();
}

class _ProfessionalInfoStepState
    extends State<ProfessionalInfoStep> {
  final List<String> levels = const [
    'مبتدئ',
    'متوسط',
    'متقدم',
    'خبير',
  ];

  final List<String> languages = const [
    'العربية',
    'الفرنسية',
    'الإنجليزية',
    'الإسبانية',
  ];

  InputDecoration _decoration(
      String label,
      ) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFF161616),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: widget.draft.jobTitle,
          style: const TextStyle(
            color: Colors.white,
          ),
          onChanged: (value) {
            widget.draft.jobTitle = value;
          },
          decoration: _decoration(
            'المسمى المهني',
          ),
        ),

        const SizedBox(
          height: 12,
        ),

        TextFormField(
          initialValue:
          widget.draft.yearsOfExperience
              .toString(),
          keyboardType: TextInputType.number,
          style: const TextStyle(
            color: Colors.white,
          ),
          onChanged: (value) {
            widget.draft.yearsOfExperience =
                int.tryParse(value) ?? 0;
          },
          decoration: _decoration(
            'سنوات الخبرة',
          ),
        ),

        const SizedBox(
          height: 12,
        ),

        DropdownButtonFormField<String>(
          initialValue:
          widget.draft.professionalLevel
              .isEmpty
              ? null
              : widget.draft
              .professionalLevel,
          dropdownColor:
          const Color(0xFF1B1B1B),
          decoration: _decoration(
            'المستوى',
          ),
          items: levels.map(
                (level) {
              return DropdownMenuItem<String>(
                value: level,
                child: Text(
                  level,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
            },
          ).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                widget.draft.professionalLevel =
                    value;
              });
            }
          },
        ),

        const SizedBox(
          height: 12,
        ),

        TextFormField(
          initialValue: widget.draft.city,
          style: const TextStyle(
            color: Colors.white,
          ),
          onChanged: (value) {
            widget.draft.city = value;
          },
          decoration: _decoration(
            'المدينة / الولاية',
          ),
        ),

        const SizedBox(
          height: 16,
        ),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: languages.map(
                (language) {
              final isSelected =
              widget.draft.languages
                  .contains(language);

              return FilterChip(
                selected: isSelected,
                label: Text(
                  language,
                ),
                onSelected: (_) {
                  setState(() {
                    if (isSelected) {
                      widget.draft.languages
                          .remove(language);
                    } else {
                      widget.draft.languages
                          .add(language);
                    }
                  });

                  widget.onChanged();
                },
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}