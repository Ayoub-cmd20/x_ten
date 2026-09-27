import 'package:flutter/material.dart';

import '../../data/influencer_categories_data.dart';
import '../../domain/models/influencer_registration_draft.dart';

class CategoriesStep extends StatefulWidget {
  final InfluencerRegistrationDraft draft;
  final VoidCallback onChanged;

  const CategoriesStep({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  @override
  State<CategoriesStep> createState() => _CategoriesStepState();
}

class _CategoriesStepState extends State<CategoriesStep> {
  static const Color gold = Color(0xFFE5C158);

  void _toggleCategory({
    required String category,
    required bool primary,
  }) {
    final selected = primary
        ? widget.draft.primaryCategories
        : widget.draft.secondaryCategories;

    final other = primary
        ? widget.draft.secondaryCategories
        : widget.draft.primaryCategories;

    if (selected.contains(category)) {
      setState(() {
        selected.remove(category);
      });
      widget.onChanged();
      return;
    }

    if (other.contains(category)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'لا يمكن اختيار نفس المجال كرئيسي وثانوي.',
            textDirection: TextDirection.rtl,
          ),
        ),
      );
      return;
    }

    if (selected.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يمكن اختيار 3 مجالات فقط.',
            textDirection: TextDirection.rtl,
          ),
        ),
      );
      return;
    }

    setState(() {
      selected.add(category);
    });

    widget.onChanged();
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required List<String> selected,
    required bool primary,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '${selected.length}/3',
                style: const TextStyle(
                  color: gold,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: influencerCategories.map((item) {
              final isSelected =
              selected.contains(item.arabicName);

              return FilterChip(
                selected: isSelected,
                label: Text(item.arabicName),
                showCheckmark: true,
                checkmarkColor: gold,
                selectedColor: gold.withValues(alpha: 0.16),
                backgroundColor: const Color(0xFF202020),
                side: BorderSide(
                  color: isSelected
                      ? gold.withValues(alpha: 0.35)
                      : Colors.white.withValues(alpha: 0.05),
                ),
                labelStyle: TextStyle(
                  color: isSelected ? gold : Colors.white70,
                  fontWeight: isSelected
                      ? FontWeight.w700
                      : FontWeight.normal,
                ),
                onSelected: (_) {
                  _toggleCategory(
                    category: item.arabicName,
                    primary: primary,
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSection(
          title: 'المجالات الرئيسية',
          subtitle: 'اختر حتى 3 مجالات رئيسية تمثل نشاطك الأساسي.',
          selected: widget.draft.primaryCategories,
          primary: true,
        ),
        const SizedBox(height: 16),
        _buildSection(
          title: 'المجالات الثانوية',
          subtitle: 'اختر حتى 3 مجالات إضافية.',
          selected: widget.draft.secondaryCategories,
          primary: false,
        ),
      ],
    );
  }
}