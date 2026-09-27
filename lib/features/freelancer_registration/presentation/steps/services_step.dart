import 'package:flutter/material.dart';

import '../../data/freelancer_services_data.dart';
import '../../domain/models/freelancer_registration_draft.dart';

class ServicesStep extends StatefulWidget {
  final FreelancerRegistrationDraft draft;
  final VoidCallback onChanged;

  const ServicesStep({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  @override
  State<ServicesStep> createState() =>
      _ServicesStepState();
}

class _ServicesStepState
    extends State<ServicesStep> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: freelancerServices.map(
            (service) {
          final isSelected =
          widget.draft.services
              .contains(service);

          return FilterChip(
            selected: isSelected,
            label: Text(
              service,
            ),
            onSelected: (_) {
              setState(() {
                if (isSelected) {
                  widget.draft.services
                      .remove(service);
                } else {
                  widget.draft.services
                      .add(service);
                }
              });

              widget.onChanged();
            },
          );
        },
      ).toList(),
    );
  }
}