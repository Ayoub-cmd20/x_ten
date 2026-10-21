import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:x_ten/core/errors/failure_message.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_colors.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/utils/file_rules.dart';
import 'package:x_ten/core/utils/upload_file.dart';
import 'package:x_ten/core/widgets/feedback/app_snackbar.dart';
import 'package:x_ten/core/widgets/form_helpers.dart';

final digitsOnly = FilteringTextInputFormatter.digitsOnly;

String registrationFailureText(BuildContext context, Failure failure) {
  final l10n = context.l10n;
  if (failure is ValidationFailure) {
    switch (failure.fieldError('file')) {
      case 'badExtension':
        return l10n.fileBadExtension;
      case 'tooLarge':
        return l10n.fileTooLarge;
    }
    if (failure.details['audience'] != null) return l10n.audienceMustTotal;
    if (failure.details['consents'] != null) return l10n.acceptAllConsents;
  }
  switch (failure.code) {
    case 'document_unrecognized':
      return l10n.docUnrecognized;
    case 'screenshot_unrecognized':
      return l10n.screenshotUnrecognized;
    case 'ocr_unavailable':
      return l10n.ocrUnavailable;
    case 'screenshot_wrong_platform':
      return l10n.screenshotWrongPlatform;
    case 'screenshot_wrong_account':
      return l10n.screenshotWrongAccount;
  }
  return failure.localized(context);
}

void showRegistrationFailure(BuildContext context, Failure failure) =>
    showErrorSnackBar(context, registrationFailureText(context, failure));

Future<UploadFile?> pickDocumentFile() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: FileRules.documents.extensions.toList(),
  );
  final file = result?.files.singleOrNull;
  final path = file?.path;
  if (file == null || path == null) return null;
  return UploadFile(path: path, name: file.name, size: file.size);
}

Future<UploadFile?> pickPhoto(ImageSource source) async {
  final image = await ImagePicker().pickImage(source: source, maxWidth: 1600, imageQuality: 85);
  if (image == null) return null;
  return UploadFile(path: image.path, name: image.name, size: await File(image.path).length());
}

class StepBody extends StatelessWidget {
  const StepBody({super.key, required this.children, required this.actions});

  final List<Widget> children;
  final Widget actions;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: AppSpacing.screen,
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xs, AppSpacing.lg, AppSpacing.md),
              child: actions,
            ),
          ),
        ],
      );
}

class StepActions extends StatelessWidget {
  const StepActions({
    super.key,
    required this.onNext,
    this.onBack,
    this.nextLabel,
    this.isLoading = false,
  });

  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final String? nextLabel;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final back = onBack;
    return Row(
      children: [
        if (back != null) ...[
          Expanded(
            flex: 2,
            child: OutlinedButton(onPressed: isLoading ? null : back, child: Text(context.l10n.back)),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
        Expanded(
          flex: 3,
          child: PrimaryButton(
            label: nextLabel ?? context.l10n.saveAndContinue,
            isLoading: isLoading,
            onPressed: onNext,
          ),
        ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.subtitle, this.trailing});

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final subtitle = this.subtitle;
    final trailing = this.trailing;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.textTheme.titleSmall),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(subtitle, style: context.textTheme.bodySmall),
                ],
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class ChoiceWrap extends StatelessWidget {
  const ChoiceWrap({
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

  @override
  Widget build(BuildContext context) {
    final errorText = this.errorText;
    final full = max != null && selected.length >= max!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final id in options)
              FilterChip(
                label: Text(labelOf(id)),
                selected: selected.contains(id),
                showCheckmark: false,
                onSelected: !selected.contains(id) && full
                    ? null
                    : (on) => onChanged(on ? [...selected, id] : [for (final s in selected) if (s != id) s]),
              ),
          ],
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(errorText, style: context.textTheme.bodySmall?.copyWith(color: AppColors.error)),
          ),
      ],
    );
  }
}

class PercentField extends StatelessWidget {
  const PercentField({super.key, required this.label, required this.controller, required this.onChanged});

  final String label;
  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        inputFormatters: [digitsOnly, LengthLimitingTextInputFormatter(3)],
        onChanged: (_) => onChanged(),
        decoration: InputDecoration(
          labelText: label,
          suffixText: '%',
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
        ),
      );
}

double percentOf(TextEditingController controller) => double.tryParse(controller.text) ?? 0;

String percentText(double value) => value == value.roundToDouble() ? '${value.toInt()}' : '$value';

class TotalBadge extends StatelessWidget {
  const TotalBadge({super.key, required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    final ok = (total - 100).abs() <= 0.01;
    final color = ok ? AppColors.success : AppColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: AppRadius.pillAll),
      child: Text(
        context.l10n.percentTotal(ltr('${percentText(total)}%')),
        style: context.textTheme.labelMedium?.copyWith(color: color),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.highlight,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? highlight;

  @override
  Widget build(BuildContext context) {
    final subtitle = this.subtitle;
    final colors = context.colors;
    final accent = highlight ?? colors.primary;
    return Material(
      color: colors.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lgAll,
        side: BorderSide(color: highlight?.withValues(alpha: 0.6) ?? colors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsetsDirectional.only(start: AppSpacing.md, end: AppSpacing.xs),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: accent.withValues(alpha: 0.12), borderRadius: AppRadius.mdAll),
          child: Icon(icon, color: accent, size: 22),
        ),
        title: Text(title, style: context.textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: subtitle == null
            ? null
            : Text(subtitle, style: context.textTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: trailing,
      ),
    );
  }
}

class EmptyHint extends StatelessWidget {
  const EmptyHint({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: AppRadius.lgAll,
          border: Border.all(color: context.colors.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textMuted),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(text, style: context.textTheme.bodySmall)),
          ],
        ),
      );
}

Future<T?> showFormSheet<T>(BuildContext context, Widget child) => showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(sheetContext).bottom),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
          child: child,
        ),
      ),
    );

String? requiredText(BuildContext context, String? value) =>
    (value ?? '').trim().isEmpty ? context.l10n.fieldRequired : null;

String? urlText(BuildContext context, String? value) {
  final text = (value ?? '').trim();
  if (text.isEmpty) return context.l10n.fieldRequired;
  final uri = Uri.tryParse(text);
  final ok = uri != null && (uri.scheme == 'https' || uri.scheme == 'http') && uri.host.contains('.');
  return ok ? null : context.l10n.urlInvalid;
}
