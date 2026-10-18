import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:x_ten/core/errors/failure_message.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/widgets/feedback/error_view.dart';
import 'package:x_ten/core/widgets/loading/app_loader.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_routes.dart';

class RegistrationGatePage extends StatefulWidget {
  const RegistrationGatePage({super.key});

  @override
  State<RegistrationGatePage> createState() => _RegistrationGatePageState();
}

class _RegistrationGatePageState extends State<RegistrationGatePage> {
  @override
  void initState() {
    super.initState();
    context.read<RegistrationCubit>().load();
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<RegistrationCubit, RegistrationState>(
        listenWhen: (previous, current) => current.didSucceed(RegistrationAction.load) && previous != current,
        listener: (context, state) => context.go(RegistrationRoutes.destinationFor(state.registration)),
        builder: (context, state) {
          final failure = state.failure;
          return Scaffold(
            body: SafeArea(
              child: state.didFail(RegistrationAction.load) && failure != null
                  ? ErrorView(
                      message: failure.localized(context),
                      retryLabel: context.l10n.retry,
                      onRetry: context.read<RegistrationCubit>().load,
                    )
                  : const AppLoader(),
            ),
          );
        },
      );
}
