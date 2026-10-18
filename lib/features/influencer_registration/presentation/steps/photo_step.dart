import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_colors.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/widgets/auth_image.dart';
import 'package:x_ten/core/widgets/loading/app_loader.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_widgets.dart';

class PhotoStep extends StatelessWidget {
  const PhotoStep({super.key});

  Future<void> _choose(BuildContext context) async {
    final cubit = context.read<RegistrationCubit>();
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
    if (source == null) return;
    final image = await pickPhoto(source);
    if (image != null) await cubit.uploadPhoto(image);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<RegistrationCubit>().state;
    final cubit = context.read<RegistrationCubit>();
    final registration = state.registration;
    final url = registration?.profileImageUrl;
    final busy = state.isLoadingFor(RegistrationAction.uploadPhoto) || state.isLoadingFor(RegistrationAction.deletePhoto);

    return StepBody(
      actions: StepActions(onBack: cubit.back, onNext: state.isLoading ? null : cubit.next, nextLabel: l10n.next),
      children: [
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.photoTitle, textAlign: TextAlign.center, style: context.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(l10n.photoSubtitle, textAlign: TextAlign.center, style: context.textTheme.bodySmall),
        const SizedBox(height: AppSpacing.xxl),
        Center(
          child: GestureDetector(
            onTap: busy ? null : () => _choose(context),
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold, width: 2),
              ),
              padding: const EdgeInsets.all(AppSpacing.xxs),
              child: ClipOval(
                child: busy
                    ? const ColoredBox(color: AppColors.surfaceHigh, child: AppLoader())
                    : AuthImage(
                        url: url,
                        width: 152,
                        height: 152,
                        cacheKey: url == null ? null : '$url#${registration?.updatedAt?.millisecondsSinceEpoch}',
                        fallback: const ColoredBox(
                          color: AppColors.surfaceHigh,
                          child: Icon(Icons.add_a_photo_outlined, size: 40, color: AppColors.textMuted),
                        ),
                      ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Center(
          child: Wrap(
            spacing: AppSpacing.sm,
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48)),
                onPressed: busy ? null : () => _choose(context),
                icon: const Icon(Icons.photo_outlined),
                label: Text(url == null ? l10n.choosePhoto : l10n.changePhoto),
              ),
              if (url != null)
                TextButton.icon(
                  onPressed: busy ? null : cubit.deletePhoto,
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: Text(l10n.removePhoto),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
