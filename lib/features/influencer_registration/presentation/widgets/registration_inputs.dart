import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/widgets/step_form.dart';

/// اختيار مرتّب: الضغط يزيد العنصر في آخر الترتيب، والأسهم تبدّل الترتيب.
class RankedPicker extends StatelessWidget {
  const RankedPicker({
    super.key,
    required this.options,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
    this.max,
    this.errorText,
  });

  final List<String> options;
  final List<String> selected;
  final String Function(String id) labelOf;
  final ValueChanged<List<String>> onChanged;
  final int? max;
  final String? errorText;

  void _move(int from, int to) {
    final next = [...selected];
    final item = next.removeAt(from);
    next.insert(to, item);
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final errorText = this.errorText;
    final full = max != null && selected.length >= max!;
    final remaining = [for (final id in options) if (!selected.contains(id)) id];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, id) in selected.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Container(
              padding: const EdgeInsetsDirectional.only(start: AppSpacing.sm),
              decoration: BoxDecoration(
                color: context.colors.surfaceContainer,
                borderRadius: AppRadius.mdAll,
                border: Border.all(color: context.palette.primary.withValues(alpha: 0.35)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 13,
                    backgroundColor: context.palette.primary,
                    child: Text(
                      '${index + 1}',
                      style: context.textTheme.labelMedium?.copyWith(color: context.palette.onPrimary),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(labelOf(id), style: context.textTheme.bodyMedium)),
                  IconButton(
                    tooltip: l10n.moveUp,
                    visualDensity: VisualDensity.compact,
                    onPressed: index == 0 ? null : () => _move(index, index - 1),
                    icon: const Icon(Icons.keyboard_arrow_up_rounded),
                  ),
                  IconButton(
                    tooltip: l10n.moveDown,
                    visualDensity: VisualDensity.compact,
                    onPressed: index == selected.length - 1 ? null : () => _move(index, index + 1),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                  IconButton(
                    tooltip: l10n.delete,
                    visualDensity: VisualDensity.compact,
                    onPressed: () => onChanged([for (final s in selected) if (s != id) s]),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
          ),
        if (remaining.isNotEmpty)
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final id in remaining)
                ActionChip(
                  avatar: const Icon(Icons.add_rounded, size: 18),
                  label: Text(labelOf(id)),
                  onPressed: full ? null : () => onChanged([...selected, id]),
                ),
            ],
          ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(errorText, style: context.textTheme.bodySmall?.copyWith(color: context.palette.error)),
          ),
      ],
    );
  }
}

/// مجموعة نسب مئوية (مجموعها 100%) بشبكة حقول.
class PercentGroup extends StatelessWidget {
  const PercentGroup({
    super.key,
    required this.title,
    required this.controllers,
    required this.labelOf,
    required this.onChanged,
    this.subtitle,
    this.columns = 3,
    this.showError = false,
  });

  final String title;
  final String? subtitle;
  final Map<String, TextEditingController> controllers;
  final String Function(String id) labelOf;
  final VoidCallback onChanged;
  final int columns;
  final bool showError;

  double get total => controllers.values.fold(0, (sum, c) => sum + percentOf(c));

  bool get isBalanced => total == 0 || (total - 100).abs() <= 0.01;

  @override
  Widget build(BuildContext context) {
    final entries = controllers.entries.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Align(alignment: AlignmentDirectional.centerEnd, child: TotalBadge(total: total)),
          )
        else
          SectionTitle(title, subtitle: subtitle, trailing: TotalBadge(total: total)),
        LayoutBuilder(
          builder: (context, constraints) {
            const gap = AppSpacing.xs;
            final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: AppSpacing.sm,
              children: [
                for (final entry in entries)
                  SizedBox(
                    width: width,
                    child: PercentField(label: labelOf(entry.key), controller: entry.value, onChanged: onChanged),
                  ),
              ],
            );
          },
        ),
        if (showError && !isBalanced)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              context.l10n.audienceMustTotal,
              style: context.textTheme.bodySmall?.copyWith(color: context.palette.error),
            ),
          ),
      ],
    );
  }
}

Map<String, TextEditingController> percentControllers(List<String> keys, Map<String, double> values) => {
      for (final key in keys) key: TextEditingController(text: (values[key] ?? 0) > 0 ? percentText(values[key]!) : ''),
    };

Map<String, double> percentValues(Map<String, TextEditingController> controllers) => {
      for (final entry in controllers.entries)
        if (percentOf(entry.value) > 0) entry.key: percentOf(entry.value),
    };

/// صورة من منصة خارجية (يوتيوب...): بلا توكن تاعنا.
class ExternalAvatar extends StatelessWidget {
  const ExternalAvatar({super.key, required this.url, required this.fallbackIcon, this.size = 40});

  final String url;
  final IconData fallbackIcon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: context.palette.primary.withValues(alpha: 0.12), borderRadius: AppRadius.mdAll),
      child: Icon(fallbackIcon, color: context.palette.primary, size: size * 0.55),
    );
    if (url.isEmpty) return fallback;
    return ClipRRect(
      borderRadius: AppRadius.mdAll,
      child: CachedNetworkImage(
        imageUrl: url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorWidget: (_, _, _) => fallback,
        placeholder: (_, _) => fallback,
      ),
    );
  }
}
