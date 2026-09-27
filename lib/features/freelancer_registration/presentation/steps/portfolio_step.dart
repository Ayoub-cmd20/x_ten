import 'package:flutter/material.dart';

import '../../domain/models/freelancer_portfolio_item.dart';
import '../../domain/models/freelancer_registration_draft.dart';

class PortfolioStep extends StatefulWidget {
  final FreelancerRegistrationDraft draft;
  final VoidCallback onChanged;

  const PortfolioStep({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  @override
  State<PortfolioStep> createState() =>
      _PortfolioStepState();
}

class _PortfolioStepState
    extends State<PortfolioStep> {
  Future<void> _addPortfolioItem() async {
    final titleController =
    TextEditingController();

    final descriptionController =
    TextEditingController();

    final categoryController =
    TextEditingController();

    final urlController =
    TextEditingController();

    final result =
    await showDialog<FreelancerPortfolioItem>(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor:
            const Color(0xFF171717),

            title: const Text(
              'إضافة عمل',
              style: TextStyle(
                color: Colors.white,
              ),
            ),

            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller:
                    titleController,
                    decoration:
                    const InputDecoration(
                      labelText: 'العنوان',
                    ),
                  ),

                  TextField(
                    controller:
                    categoryController,
                    decoration:
                    const InputDecoration(
                      labelText: 'النوع',
                    ),
                  ),

                  TextField(
                    controller:
                    descriptionController,
                    decoration:
                    const InputDecoration(
                      labelText: 'الوصف',
                    ),
                  ),

                  TextField(
                    controller:
                    urlController,
                    decoration:
                    const InputDecoration(
                      labelText: 'الرابط',
                    ),
                  ),
                ],
              ),
            ),

            actions: [
              ElevatedButton(
                onPressed: () {
                  if (titleController.text
                      .trim()
                      .isNotEmpty) {
                    Navigator.pop(
                      dialogContext,
                      FreelancerPortfolioItem(
                        id: DateTime.now()
                            .microsecondsSinceEpoch
                            .toString(),
                        title:
                        titleController.text
                            .trim(),
                        description:
                        descriptionController
                            .text
                            .trim(),
                        category:
                        categoryController
                            .text
                            .trim(),
                        externalUrl:
                        urlController.text
                            .trim()
                            .isEmpty
                            ? null
                            : urlController
                            .text
                            .trim(),
                      ),
                    );
                  }
                },
                child: const Text(
                  'حفظ',
                ),
              ),
            ],
          ),
        );
      },
    );

    titleController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    urlController.dispose();

    if (result != null) {
      setState(() {
        widget.draft.portfolio.add(
          result,
        );
      });

      widget.onChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...widget.draft.portfolio.map(
              (portfolioItem) {
            return ListTile(
              title: Text(
                portfolioItem.title,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),

              subtitle: Text(
                portfolioItem.category,
              ),

              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    widget.draft.portfolio
                        .remove(
                      portfolioItem,
                    );
                  });

                  widget.onChanged();
                },
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                ),
              ),
            );
          },
        ),

        OutlinedButton.icon(
          onPressed: _addPortfolioItem,
          icon: const Icon(
            Icons.add,
          ),
          label: const Text(
            'إضافة عمل سابق',
          ),
        ),
      ],
    );
  }
}