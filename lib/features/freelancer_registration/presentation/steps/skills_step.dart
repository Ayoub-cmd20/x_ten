import 'package:flutter/material.dart';

import '../../data/freelancer_skills_data.dart';
import '../../domain/models/freelancer_registration_draft.dart';
import '../../domain/models/freelancer_skill.dart';

class SkillsStep extends StatefulWidget {
  final FreelancerRegistrationDraft draft;
  final VoidCallback onChanged;

  const SkillsStep({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  @override
  State<SkillsStep> createState() =>
      _SkillsStepState();
}

class _SkillsStepState extends State<SkillsStep> {
  Future<void> _addSkill(
      String skillName,
      ) async {
    SkillLevel selectedLevel =
        SkillLevel.intermediate;

    final selectedSkill =
    await showDialog<FreelancerSkill>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
              context,
              setDialogState,
              ) {
            return Directionality(
              textDirection:
              TextDirection.rtl,
              child: AlertDialog(
                backgroundColor:
                const Color(
                  0xFF171717,
                ),

                title: Text(
                  skillName,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),

                content:
                DropdownButtonFormField<
                    SkillLevel>(
                  initialValue:
                  selectedLevel,

                  items:
                  SkillLevel.values.map(
                        (level) {
                      return DropdownMenuItem<
                          SkillLevel>(
                        value: level,
                        child: Text(
                          level.arabicName,
                        ),
                      );
                    },
                  ).toList(),

                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() {
                        selectedLevel =
                            value;
                      });
                    }
                  },
                ),

                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                        dialogContext,
                        FreelancerSkill(
                          name:
                          skillName,
                          level:
                          selectedLevel,
                        ),
                      );
                    },
                    child: const Text(
                      'إضافة',
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (selectedSkill != null) {
      setState(() {
        widget.draft.skills
            .removeWhere(
              (skill) =>
          skill.name ==
              skillName,
        );

        widget.draft.skills.add(
          selectedSkill,
        );
      });

      widget.onChanged();
    }
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
          freelancerSuggestedSkills.map(
                (skillName) {
              return ActionChip(
                label: Text(
                  skillName,
                ),
                onPressed: () {
                  _addSkill(
                    skillName,
                  );
                },
              );
            },
          ).toList(),
        ),

        const SizedBox(
          height: 12,
        ),

        ...widget.draft.skills.map(
              (skill) {
            return ListTile(
              title: Text(
                skill.name,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),

              subtitle: Text(
                skill.level.arabicName,
              ),

              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    widget.draft.skills
                        .remove(
                      skill,
                    );
                  });

                  widget.onChanged();
                },

                icon: const Icon(
                  Icons.delete_outline,
                  color:
                  Colors.redAccent,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}