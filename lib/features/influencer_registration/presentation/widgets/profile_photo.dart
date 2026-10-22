import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/widgets/photo_picker.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';

class ProfilePhotoPicker extends StatelessWidget {
  const ProfilePhotoPicker({super.key, this.showError = false});

  final bool showError;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RegistrationCubit>().state;
    final cubit = context.read<RegistrationCubit>();
    final registration = state.registration;
    final url = registration?.profileImageUrl;

    return PhotoPicker(
      url: url,
      cacheKey: url == null ? null : '$url#${registration?.updatedAt?.millisecondsSinceEpoch}',
      busy: state.isLoadingFor(RegistrationAction.uploadPhoto) || state.isLoadingFor(RegistrationAction.deletePhoto),
      showError: showError,
      subtitle: context.l10n.regPhotoSubtitle,
      onPicked: cubit.uploadPhoto,
      onRemove: cubit.deletePhoto,
    );
  }
}
