import 'package:flutter/material.dart';

import '../../domain/models/freelancer_registration_draft.dart';
import '../../domain/models/freelancer_registration.dart';

class RegistrationReviewStep extends StatelessWidget {
  final FreelancerRegistrationDraft draft;
  final ValueChanged<int> onEdit;

  const RegistrationReviewStep({
    super.key,
    required this.draft,
    required this.onEdit,
  });

  Widget _buildItem(
      String title,
      String value,
      int stepIndex,
      ) {
    return Card(
      color: const Color(0xFF151515),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          value.isEmpty ? 'غير محدد' : value,
          style: const TextStyle(
            color: Colors.white54,
          ),
        ),
        trailing: TextButton(
          onPressed: () {
            onEdit(stepIndex);
          },
          child: const Text(
            'تعديل',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildItem(
          'المعلومات الشخصية',
          '${draft.firstName} ${draft.lastName} - ${draft.displayName}',
          0,
        ),

        _buildItem(
          'المعلومات المهنية',
          '${draft.jobTitle} • ${draft.yearsOfExperience} سنوات',
          1,
        ),

        _buildItem(
          'الخدمات',
          draft.services.join('، '),
          2,
        ),

        _buildItem(
          'المهارات',
          draft.skills
              .map(
                (skill) => skill.name,
          )
              .join('، '),
          3,
        ),

        _buildItem(
          'معرض الأعمال',
          '${draft.portfolio.length} عمل',
          4,
        ),

        _buildItem(
          'الاتصال',
          '${draft.email}\n${draft.phone}',
          5,
        ),

        _buildItem(
          'المعلومات المالية',
          draft.paymentType.arabicName,
          6,
        ),

        _buildItem(
          'الوثائق',
          '${draft.documents.length} ملف',
          7,
        ),

        _buildItem(
          'فرص العمل',
          draft.availability.arabicName,
          8,
        ),

        _buildItem(
          'الشروط',
          draft.acceptTerms
              ? 'مكتملة'
              : 'غير مكتملة',
          9,
        ),
      ],
    );
  }
}