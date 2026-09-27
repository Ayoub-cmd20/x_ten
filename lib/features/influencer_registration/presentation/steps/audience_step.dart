import 'package:flutter/material.dart';

import '../../domain/models/influencer_registration_draft.dart';

class AudienceStep extends StatefulWidget {
  final InfluencerRegistrationDraft draft;
  final VoidCallback onChanged;

  const AudienceStep({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  @override
  State<AudienceStep> createState() => _AudienceStepState();
}

class _AudienceStepState extends State<AudienceStep> {
  static const Color gold = Color(0xFFE5C158);

  final List<String> _interests = const [
    'التكنولوجيا',
    'الرياضة',
    'السيارات',
    'الموضة',
    'الجمال',
    'السفر',
    'الطبخ',
    'الألعاب',
    'التعليم',
    'التجارة الإلكترونية',
    'الترفيه',
    'الصحة',
  ];

  void _updateAge(String key, double value) {
    setState(() {
      widget.draft.ageDistribution[key] = value;
    });
    widget.onChanged();
  }

  Future<void> _addLocation() async {
    final nameController = TextEditingController();
    final percentageController = TextEditingController();

    final result = await showDialog<MapEntry<String, double>>(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: const Color(0xFF171717),
            title: const Text(
              'إضافة موقع جغرافي',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'الدولة / الولاية',
                  ),
                ),
                TextField(
                  controller: percentageController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'النسبة %',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  final percentage = double.tryParse(
                    percentageController.text.trim(),
                  );

                  if (name.isEmpty || percentage == null) {
                    return;
                  }

                  Navigator.pop(
                    dialogContext,
                    MapEntry(name, percentage.clamp(0, 100)),
                  );
                },
                child: const Text('إضافة'),
              ),
            ],
          ),
        );
      },
    );

    nameController.dispose();
    percentageController.dispose();

    if (result == null || !mounted) return;

    setState(() {
      widget.draft.audienceLocations[result.key] =
          result.value;
    });

    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'بيانات الجمهور',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'أدخل تقديراً تقريبياً لتوزيع جمهورك حسب العمر والجنس والموقع والاهتمامات.',
          style: TextStyle(
            color: Colors.white54,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 20),

        _sectionTitle('العمر'),

        ...widget.draft.ageDistribution.entries.map(
              (entry) => Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.key,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                  Text(
                    '${entry.value.round()}%',
                    style: const TextStyle(
                      color: gold,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Slider(
                value: entry.value.clamp(0, 100),
                min: 0,
                max: 100,
                activeColor: gold,
                inactiveColor: Colors.white12,
                onChanged: (value) {
                  _updateAge(entry.key, value);
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        _sectionTitle('الجنس'),

        Slider(
          value: widget.draft.malePercentage.clamp(0, 100),
          min: 0,
          max: 100,
          activeColor: gold,
          inactiveColor: Colors.white12,
          onChanged: (value) {
            setState(() {
              widget.draft.malePercentage = value;
              widget.draft.femalePercentage = 100 - value;
            });
            widget.onChanged();
          },
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'رجال ${widget.draft.malePercentage.round()}%',
              style: const TextStyle(color: Colors.white70),
            ),
            Text(
              'نساء ${widget.draft.femalePercentage.round()}%',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),

        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(child: _sectionTitle('الموقع الجغرافي')),
            TextButton.icon(
              onPressed: _addLocation,
              icon: const Icon(
                Icons.add,
                color: gold,
                size: 18,
              ),
              label: const Text(
                'إضافة',
                style: TextStyle(color: gold),
              ),
            ),
          ],
        ),

        if (widget.draft.audienceLocations.isEmpty)
          const Text(
            'لم تتم إضافة مواقع بعد.',
            style: TextStyle(color: Colors.white38),
          )
        else
          ...widget.draft.audienceLocations.entries.map(
                (entry) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                entry.key,
                style: const TextStyle(color: Colors.white),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${entry.value.round()}%',
                    style: const TextStyle(color: gold),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.draft.audienceLocations
                            .remove(entry.key);
                      });
                      widget.onChanged();
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white38,
                    ),
                  ),
                ],
              ),
            ),
          ),

        const SizedBox(height: 22),

        _sectionTitle('اهتمامات الجمهور'),

        const SizedBox(height: 10),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _interests.map((item) {
            final selected =
            widget.draft.audienceInterests.contains(item);

            return FilterChip(
              selected: selected,
              label: Text(item),
              selectedColor: gold.withValues(alpha: 0.15),
              checkmarkColor: gold,
              backgroundColor: const Color(0xFF181818),
              labelStyle: TextStyle(
                color: selected ? gold : Colors.white70,
              ),
              onSelected: (_) {
                setState(() {
                  if (selected) {
                    widget.draft.audienceInterests.remove(item);
                  } else {
                    widget.draft.audienceInterests.add(item);
                  }
                });

                widget.onChanged();
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}