import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/widgets/containers/invisible_container.dart';
import 'package:flutter/material.dart';

class ProgressContainer extends StatelessWidget {
  const ProgressContainer({required this.isProcessing, required this.child});

  final bool isProcessing;
  final Widget child;

  Widget get _progressItem => Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InvisibleContainer(isInvisible: isProcessing, child: child),
        if (isProcessing)
          Positioned(
            child: _progressItem,
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
          )
      ],
    );
  }
}
