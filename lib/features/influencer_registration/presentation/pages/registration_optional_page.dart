import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/errors/failure_message.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/widgets/feedback/error_view.dart';
import 'package:x_ten/core/widgets/loading/app_loader.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';
import 'package:x_ten/features/influencer_registration/presentation/steps/optional_step.dart';

/// حصر الجمهور، المهارات، أنواع المحتوى ومعرض الأعمال: تتكمّل حتى بعد الإرسال والتوثيق.
class RegistrationOptionalPage extends StatefulWidget {
  const RegistrationOptionalPage({super.key});

  @override
  State<RegistrationOptionalPage> createState() => _RegistrationOptionalPageState();
}

class _RegistrationOptionalPageState extends State<RegistrationOptionalPage> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<RegistrationCubit>();
    if (!cubit.state.loaded) cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<RegistrationCubit>().state;
    final registration = state.registration;
    final failure = state.failure;

    final Widget body;
    if (!state.loaded) {
      body = state.didFail(RegistrationAction.load) && failure != null
          ? ErrorView(
              message: failure.localized(context),
              retryLabel: l10n.retry,
              onRetry: context.read<RegistrationCubit>().load,
            )
          : const AppLoader();
    } else if (registration == null || !registration.canEditOptional) {
      body = Center(child: Text(l10n.errorConflict, textAlign: TextAlign.center));
    } else {
      body = const OptionalStep(inWizard: false);
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.regStepOptional)),
      body: SafeArea(child: body),
    );
  }
}
