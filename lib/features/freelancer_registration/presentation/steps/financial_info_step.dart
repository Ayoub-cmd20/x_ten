import 'package:flutter/material.dart';

import '../../domain/models/freelancer_registration.dart';
import '../../domain/models/freelancer_registration_draft.dart';

class FinancialInfoStep extends StatefulWidget {
  final FreelancerRegistrationDraft draft;
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

class _FinancialInfoStepState
    extends State<FinancialInfoStep> {
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
    final paymentType =
        widget.draft.paymentType;

    return Column(
      children: [
        RadioGroup<FreelancerPaymentType>(
          groupValue: paymentType,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                widget.draft.paymentType =
                    value;
              });

              widget.onChanged();
            }
          },
          child: Column(
            children:
            FreelancerPaymentType.values
                .map(
                  (
                  paymentMethod,
                  ) {
                return RadioListTile<
                    FreelancerPaymentType>(
                  value:
                  paymentMethod,
                  title: Text(
                    paymentMethod
                        .arabicName,
                    style:
                    const TextStyle(
                      color:
                      Colors.white,
                    ),
                  ),
                );
              },
            )
                .toList(),
          ),
        ),

        if (paymentType ==
            FreelancerPaymentType.ccp ||
            paymentType ==
                FreelancerPaymentType.both)
          ...[
            TextFormField(
              initialValue:
              widget.draft.ccpAccount,
              style: const TextStyle(
                color: Colors.white,
              ),
              onChanged: (value) {
                widget.draft.ccpAccount =
                    value;
              },
              decoration: _decoration(
                'رقم CCP',
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            TextFormField(
              initialValue:
              widget.draft.ccpKey,
              style: const TextStyle(
                color: Colors.white,
              ),
              onChanged: (value) {
                widget.draft.ccpKey =
                    value;
              },
              decoration: _decoration(
                'Clé CCP',
              ),
            ),
          ],

        if (paymentType ==
            FreelancerPaymentType.bank ||
            paymentType ==
                FreelancerPaymentType.both)
          ...[
            TextFormField(
              initialValue:
              widget.draft.bankName,
              style: const TextStyle(
                color: Colors.white,
              ),
              onChanged: (value) {
                widget.draft.bankName =
                    value;
              },
              decoration: _decoration(
                'اسم البنك',
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            TextFormField(
              initialValue:
              widget.draft.bankAccount,
              style: const TextStyle(
                color: Colors.white,
              ),
              onChanged: (value) {
                widget.draft.bankAccount =
                    value;
              },
              decoration: _decoration(
                'رقم الحساب البنكي',
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            TextFormField(
              initialValue:
              widget.draft.rib,
              style: const TextStyle(
                color: Colors.white,
              ),
              onChanged: (value) {
                widget.draft.rib =
                    value;
              },
              decoration: _decoration(
                'RIB',
              ),
            ),
          ],
      ],
    );
  }
}