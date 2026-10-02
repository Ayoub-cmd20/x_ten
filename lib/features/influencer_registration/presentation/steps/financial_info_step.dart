import 'package:flutter/material.dart';

import '../../domain/models/financial_information.dart';
import '../../domain/models/influencer_registration_draft.dart';

class FinancialInfoStep extends StatefulWidget {
  final InfluencerRegistrationDraft draft;
  final VoidCallback onChanged;

  const FinancialInfoStep({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  @override
  State<FinancialInfoStep> createState() =>
      _FinancialInfoStepState();
}

class _FinancialInfoStepState extends State<FinancialInfoStep> {
  static const Color gold = Color(0xFFE5C158);

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: const Color(0xFF161616),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: gold),
      ),
    );
  }

  void _setType(PaymentAccountType? value) {
    if (value == null) return;

    setState(() {
      widget.draft.paymentType = value;
    });

    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.draft.paymentType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'المعلومات المالية',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'اختر الحساب الذي تريد استعماله لاستلام مستحقاتك.',
          style: TextStyle(
            color: Colors.white54,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 16),

        RadioGroup<PaymentAccountType>(
          groupValue: type,
          onChanged: _setType,
          child: Column(
            children: PaymentAccountType.values.map(
              (item) => RadioListTile<PaymentAccountType>(
                value: item,
                activeColor: gold,
                title: Text(
                  item.arabicName,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ).toList(),
          ),
        ),

        if (type == PaymentAccountType.ccp ||
            type == PaymentAccountType.both) ...[
          const SizedBox(height: 10),

          TextFormField(
            initialValue: widget.draft.ccpAccount,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            onChanged: (value) {
              widget.draft.ccpAccount = value;
              widget.onChanged();
            },
            decoration: _decoration('رقم الحساب البريدي CCP'),
          ),

          const SizedBox(height: 12),

          TextFormField(
            initialValue: widget.draft.ccpKey,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            onChanged: (value) {
              widget.draft.ccpKey = value;
              widget.onChanged();
            },
            decoration: _decoration('Clé CCP'),
          ),
        ],

        if (type == PaymentAccountType.bank ||
            type == PaymentAccountType.both) ...[
          const SizedBox(height: 14),

          TextFormField(
            initialValue: widget.draft.bankName,
            style: const TextStyle(color: Colors.white),
            onChanged: (value) {
              widget.draft.bankName = value;
              widget.onChanged();
            },
            decoration: _decoration('اسم البنك'),
          ),

          const SizedBox(height: 12),

          TextFormField(
            initialValue: widget.draft.bankAccount,
            style: const TextStyle(color: Colors.white),
            onChanged: (value) {
              widget.draft.bankAccount = value;
              widget.onChanged();
            },
            decoration: _decoration('رقم الحساب البنكي'),
          ),

          const SizedBox(height: 12),

          TextFormField(
            initialValue: widget.draft.rib,
            style: const TextStyle(color: Colors.white),
            onChanged: (value) {
              widget.draft.rib = value;
              widget.onChanged();
            },
            decoration: _decoration('RIB'),
          ),
        ],

        const SizedBox(height: 18),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: gold.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.lock_outline_rounded,
                color: gold,
                size: 19,
              ),
              SizedBox(width: 9),
              Expanded(
                child: Text(
                  'هذه المعلومات مالية وحساسة، ويجب عدم عرضها في الملف العام للمؤثر.',
                  style: TextStyle(
                    color: Colors.white54,
                    height: 1.5,
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
}