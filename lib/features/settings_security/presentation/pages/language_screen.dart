import 'package:flutter/material.dart';

import 'package:x_ten/core/localization/locale_controller.dart';
import 'package:x_ten/core/localization/localization_extension.dart';

class LanguageScreen
    extends StatelessWidget {
  const LanguageScreen({
    super.key,
  });

  static const Color background =
  Color(0xFF090909);

  static const Color cardColor =
  Color(0xFF151515);

  static const Color gold =
  Color(0xFFE5C158);

  @override
  Widget build(
      BuildContext context,
      ) {
    final selected =
        localeController.locale.languageCode;

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,

        elevation: 0,

        title: Text(
          context.l10n.selectLanguage,
        ),
      ),

      body: ListView(
        padding:
        const EdgeInsets.all(20),

        children: [
          _LanguageCard(
            flag: '🇩🇿',
            title: 'العربية',
            subtitle: 'Arabic',
            selected:
            selected == 'ar',
            onTap: () {
              localeController
                  .setArabic();
            },
          ),

          const SizedBox(
            height: 14,
          ),

          _LanguageCard(
            flag: '🇫🇷',
            title: 'Français',
            subtitle: 'French',
            selected:
            selected == 'fr',
            onTap: () {
              localeController
                  .setFrench();
            },
          ),

          const SizedBox(
            height: 14,
          ),

          _LanguageCard(
            flag: '🇬🇧',
            title: 'English',
            subtitle: 'English',
            selected:
            selected == 'en',
            onTap: () {
              localeController
                  .setEnglish();
            },
          ),
        ],
      ),
    );
  }
}

class _LanguageCard
    extends StatelessWidget {
  final String flag;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.flag,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius:
        BorderRadius.circular(18),

        onTap: onTap,

        child: AnimatedContainer(
          duration:
          const Duration(
            milliseconds: 220,
          ),

          padding:
          const EdgeInsets.all(18),

          decoration: BoxDecoration(
            color:
            LanguageScreen.cardColor,

            borderRadius:
            BorderRadius.circular(18),

            border: Border.all(
              color: selected
                  ? LanguageScreen.gold
                  : Colors.white12,

              width:
              selected ? 1.6 : 1,
            ),

            boxShadow: selected
                ? [
              BoxShadow(
                color:
                LanguageScreen
                    .gold
                    .withValues(
                  alpha: 0.12,
                ),
                blurRadius: 22,
                spreadRadius: 1,
              ),
            ]
                : null,
          ),

          child: Row(
            children: [
              Text(
                flag,

                style:
                const TextStyle(
                  fontSize: 31,
                ),
              ),

              const SizedBox(
                width: 16,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

                  children: [
                    Text(
                      title,

                      style:
                      TextStyle(
                        fontSize: 17,

                        fontWeight:
                        FontWeight
                            .w700,

                        color: selected
                            ? LanguageScreen
                            .gold
                            : Colors.white,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      subtitle,

                      style:
                      const TextStyle(
                        color:
                        Colors.white54,

                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              AnimatedSwitcher(
                duration:
                const Duration(
                  milliseconds: 200,
                ),

                child: selected
                    ? const Icon(
                  Icons
                      .check_circle_rounded,

                  key: ValueKey(
                    'selected',
                  ),

                  color:
                  LanguageScreen
                      .gold,

                  size: 25,
                )
                    : const Icon(
                  Icons
                      .radio_button_unchecked,

                  key: ValueKey(
                    'unselected',
                  ),

                  color:
                  Colors.white24,

                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}