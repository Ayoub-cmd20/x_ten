import 'package:flutter/material.dart';

import '../../domain/models/content_type.dart';
import '../../domain/models/financial_information.dart';
import '../../domain/models/influencer_registration_draft.dart';

class RegistrationReviewStep extends StatelessWidget {
  final InfluencerRegistrationDraft draft;
  final ValueChanged<int> onEdit;

  const RegistrationReviewStep({
    super.key,
    required this.draft,
    required this.onEdit,
  });

  static const Color gold = Color(0xFFE5C158);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'مراجعة التسجيل',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'راجع المعلومات قبل إرسال طلبك إلى إدارة X Ten.',
          style: TextStyle(
            color: Colors.white54,
          ),
        ),

        const SizedBox(height: 20),

        _item(
          icon: Icons.person_outline,
          title: 'المعلومات الشخصية',
          value:
          '${draft.firstName} ${draft.lastName}\n${draft.displayName}',
          onEdit: () => onEdit(0),
        ),

        _item(
          icon: Icons.category_outlined,
          title: 'المجالات',
          value: [
            ...draft.primaryCategories,
            ...draft.secondaryCategories,
          ].join('، '),
          onEdit: () => onEdit(1),
        ),

        _item(
          icon: Icons.contact_mail_outlined,
          title: 'معلومات الاتصال',
          value: '${draft.email}\n${draft.phone}',
          onEdit: () => onEdit(2),
        ),

        _item(
          icon: Icons.account_balance_outlined,
          title: 'المعلومات المالية',
          value: draft.paymentType.arabicName,
          onEdit: () => onEdit(3),
        ),

        _item(
          icon: Icons.folder_outlined,
          title: 'الوثائق',
          value: '${draft.documents.length} ملف',
          onEdit: () => onEdit(4),
        ),

        _item(
          icon: Icons.public_outlined,
          title: 'حسابات التواصل',
          value: '${draft.socialAccounts.length} منصة',
          onEdit: () => onEdit(5),
        ),

        _item(
          icon: Icons.groups_outlined,
          title: 'الجمهور',
          value: draft.audienceLocations.isEmpty
              ? 'لم تتم إضافة مواقع'
              : draft.audienceLocations.keys.join('، '),
          onEdit: () => onEdit(6),
        ),

        _item(
          icon: Icons.video_collection_outlined,
          title: 'نوع المحتوى',
          value: draft.contentTypes
              .map((item) => item.arabicName)
              .join('، '),
          onEdit: () => onEdit(7),
        ),

        _item(
          icon: Icons.notifications_outlined,
          title: 'طريقة استقبال الطلبات',
          value: _notificationSummary(),
          onEdit: () => onEdit(8),
        ),

        _item(
          icon: Icons.verified_user_outlined,
          title: 'الشروط والموافقة',
          value: draft.acceptTerms &&
              draft.acceptPrivacy &&
              draft.acceptVerification &&
              draft.acceptContact &&
              draft.confirmInformation
              ? 'مكتملة'
              : 'غير مكتملة',
          onEdit: () => onEdit(9),
        ),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: gold.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: gold.withValues(alpha: 0.15),
            ),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: gold,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'بعد إرسال الطلب لن يصبح الحساب موثقاً مباشرة. ستقوم الإدارة بمراجعة البيانات ثم التواصل معك لتحديد اجتماع التوثيق.',
                  style: TextStyle(
                    color: Colors.white60,
                    height: 1.6,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _notificationSummary() {
    final values = <String>['داخل التطبيق'];

    if (draft.smsNotification) {
      values.add('SMS');
    }

    if (draft.phoneCallNotification) {
      values.add('مكالمة');
    }

    if (draft.emailNotification) {
      values.add('Email');
    }

    if (draft.whatsappNotification) {
      values.add('WhatsApp');
    }

    return values.join(' • ');
  }

  Widget _item({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onEdit,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: gold.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: gold,
              size: 20,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.trim().isEmpty ? 'غير محدد' : value,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white38,
                    height: 1.4,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          TextButton(
            onPressed: onEdit,
            child: const Text(
              'تعديل',
              style: TextStyle(color: gold),
            ),
          ),
        ],
      ),
    );
  }
}