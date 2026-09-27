import 'package:flutter/material.dart';

import '../../domain/models/freelancer_registration.dart';
import '../../domain/models/freelancer_registration_draft.dart';

class OpportunityPreferencesStep extends StatefulWidget {
  final FreelancerRegistrationDraft draft;
  final VoidCallback onChanged;

  const OpportunityPreferencesStep({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  @override
  State<OpportunityPreferencesStep> createState() =>
      _OpportunityPreferencesStepState();
}

class _OpportunityPreferencesStepState
    extends State<OpportunityPreferencesStep> {
  final List<String> projectTypes = const [
    'مشاريع قصيرة',
    'مشاريع طويلة',
    'عمل بالساعة',
    'عمل بسعر ثابت',
    'تعاون مستمر',
    'Remote',
    'On-site',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<FreelancerAvailability>(
          initialValue: widget.draft.availability,
          items: FreelancerAvailability.values.map(
                (availability) {
              return DropdownMenuItem<FreelancerAvailability>(
                value: availability,
                child: Text(
                  availability.arabicName,
                ),
              );
            },
          ).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                widget.draft.availability = value;
              });
            }
          },
        ),

        Slider(
          value: widget.draft.weeklyHours.toDouble(),
          min: 1,
          max: 60,
          divisions: 59,
          onChanged: (value) {
            setState(() {
              widget.draft.weeklyHours =
                  value.round();
            });

            widget.onChanged();
          },
        ),

        TextFormField(
          initialValue:
          widget.draft.minimumBudget == 0
              ? ''
              : widget.draft.minimumBudget
              .toStringAsFixed(0),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            widget.draft.minimumBudget =
                double.tryParse(value) ?? 0;
          },
          decoration: const InputDecoration(
            labelText:
            'الحد الأدنى للميزانية (دج)',
          ),
        ),

        const SizedBox(
          height: 12,
        ),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: projectTypes.map(
                (projectType) {
              final isSelected =
              widget.draft.projectPreferences
                  .contains(projectType);

              return FilterChip(
                selected: isSelected,
                label: Text(
                  projectType,
                ),
                onSelected: (_) {
                  setState(() {
                    if (isSelected) {
                      widget.draft.projectPreferences
                          .remove(
                        projectType,
                      );
                    } else {
                      widget.draft.projectPreferences
                          .add(
                        projectType,
                      );
                    }
                  });

                  widget.onChanged();
                },
              );
            },
          ).toList(),
        ),

        SwitchListTile(
          value:
          widget.draft.emailNotification,
          title: const Text(
            'Email',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onChanged: (value) {
            setState(() {
              widget.draft.emailNotification =
                  value;
            });
          },
        ),

        SwitchListTile(
          value:
          widget.draft.smsNotification,
          title: const Text(
            'SMS',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onChanged: (value) {
            setState(() {
              widget.draft.smsNotification =
                  value;
            });
          },
        ),

        SwitchListTile(
          value:
          widget.draft.whatsappNotification,
          title: const Text(
            'WhatsApp',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onChanged: (value) {
            setState(() {
              widget.draft.whatsappNotification =
                  value;
            });
          },
        ),

        SwitchListTile(
          value:
          widget.draft.phoneCallNotification,
          title: const Text(
            'مكالمة هاتفية',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onChanged: (value) {
            setState(() {
              widget.draft.phoneCallNotification =
                  value;
            });
          },
        ),
      ],
    );
  }
}