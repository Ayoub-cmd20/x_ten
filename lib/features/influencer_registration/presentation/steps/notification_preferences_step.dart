import 'package:flutter/material.dart';

import '../../domain/models/influencer_registration_draft.dart';

class NotificationPreferencesStep extends StatefulWidget {
  final InfluencerRegistrationDraft draft;
  final VoidCallback onChanged;

  const NotificationPreferencesStep({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  @override
  State<NotificationPreferencesStep> createState() =>
      _NotificationPreferencesStepState();
}

class _NotificationPreferencesStepState
    extends State<NotificationPreferencesStep> {
  static const Color gold = Color(0xFFE5C158);

  Widget _option({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool locked = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(16),
      ),
      child: SwitchListTile(
        value: value,
        activeThumbColor: gold,
        secondary: Icon(icon, color: gold),
        onChanged: locked ? null : onChanged,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  void _changed() {
    widget.onChanged();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'طريقة استقبال طلبات الإشهار',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'اختر كيف تريد أن يصلك إشعار عند وجود طلب إشهار موجه لك.',
          style: TextStyle(
            color: Colors.white54,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 20),

        _option(
          title: 'إشعار داخل التطبيق',
          subtitle: 'مفعّل دائماً لحماية حسابك ومتابعة الطلبات.',
          icon: Icons.notifications_active_outlined,
          value: true,
          locked: true,
          onChanged: (_) {},
        ),

        _option(
          title: 'SMS',
          subtitle: 'استقبال رسالة قصيرة عند وصول طلب جديد.',
          icon: Icons.sms_outlined,
          value: widget.draft.smsNotification,
          onChanged: (value) {
            widget.draft.smsNotification = value;
            _changed();
          },
        ),

        _option(
          title: 'مكالمة هاتفية',
          subtitle: 'يمكن لفريق المنصة الاتصال بك عند الحاجة.',
          icon: Icons.phone_in_talk_outlined,
          value: widget.draft.phoneCallNotification,
          onChanged: (value) {
            widget.draft.phoneCallNotification = value;
            _changed();
          },
        ),

        _option(
          title: 'البريد الإلكتروني',
          subtitle: 'إرسال تفاصيل الطلب إلى بريدك الإلكتروني.',
          icon: Icons.email_outlined,
          value: widget.draft.emailNotification,
          onChanged: (value) {
            widget.draft.emailNotification = value;
            _changed();
          },
        ),

        _option(
          title: 'WhatsApp',
          subtitle: 'استقبال تنبيه عبر WhatsApp عند تفعيله.',
          icon: Icons.chat_outlined,
          value: widget.draft.whatsappNotification,
          onChanged: (value) {
            widget.draft.whatsappNotification = value;
            _changed();
          },
        ),
      ],
    );
  }
}