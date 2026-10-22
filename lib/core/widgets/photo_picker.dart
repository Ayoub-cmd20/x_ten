import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_colors.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/utils/upload_file.dart';
import 'package:x_ten/core/widgets/auth_image.dart';
import 'package:x_ten/core/widgets/loading/app_loader.dart';
import 'package:x_ten/core/widgets/step_form.dart';

class PhotoPicker extends StatelessWidget {
  const PhotoPicker({
    super.key,
    required this.url,
    required this.busy,
    required this.subtitle,
    required this.onPicked,
    required this.onRemove,
    this.cacheKey,
    this.showError = false,
  });

  final String? url;
  final String? cacheKey;
  final bool busy;
  final bool showError;
  final String subtitle;
  final ValueChanged<UploadFile> onPicked;
  final VoidCallback onRemove;

  Future<void> _choose(BuildContext context) async {
    final l10n = context.l10n;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.fromGallery),
              onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l10n.fromCamera),
              onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null) {
      return;
    }
    final image = await pickPhoto(source);
    if (image != null) {
      onPicked(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final url = this.url;
    final missing = showError && url == null;

    return Column(
      children: [
        GestureDetector(
          onTap: busy ? null : () => _choose(context),
          child: Container(
            width: 112,
            height: 112,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: missing ? AppColors.error : AppColors.gold, width: 2),
            ),
            padding: const EdgeInsets.all(AppSpacing.xxs),
            child: ClipOval(
              child: busy
                  ? const ColoredBox(color: AppColors.surfaceHigh, child: AppLoader())
                  : AuthImage(
                      url: url,
                      width: 104,
                      height: 104,
                      cacheKey: cacheKey,
                      fallback: const ColoredBox(
                        color: AppColors.surfaceHigh,
                        child: Icon(Icons.add_a_photo_outlined, size: 32, color: AppColors.textMuted),
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(subtitle, style: context.textTheme.bodySmall, textAlign: TextAlign.center),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: AppSpacing.xs,
          children: [
            TextButton.icon(
              onPressed: busy ? null : () => _choose(context),
              icon: const Icon(Icons.photo_outlined),
              label: Text(url == null ? l10n.choosePhoto : l10n.changePhoto),
            ),
            if (url != null)
              TextButton.icon(
                onPressed: busy ? null : onRemove,
                icon: const Icon(Icons.delete_outline_rounded),
                label: Text(l10n.removePhoto),
              ),
          ],
        ),
        if (missing)
          Text(l10n.fieldRequired, style: context.textTheme.bodySmall?.copyWith(color: AppColors.error)),
      ],
    );
  }
}
