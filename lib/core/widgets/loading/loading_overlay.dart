import 'package:flutter/material.dart';
import 'package:x_ten/core/widgets/loading/app_loader.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key, required this.isLoading, required this.child});

  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: !isLoading,
        child: Stack(
          children: [
            child,
            if (isLoading) ...[
              const Positioned.fill(
                child: ModalBarrier(dismissible: false, color: Colors.black26),
              ),
              const Positioned.fill(child: AppLoader()),
            ],
          ],
        ),
      );
}
