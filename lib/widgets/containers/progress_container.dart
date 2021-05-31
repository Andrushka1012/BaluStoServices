import 'package:flutter/material.dart';

class ProgressContainer extends StatelessWidget {
  const ProgressContainer({required this.isProcessing, required this.child});

  final bool isProcessing;
  final Widget child;

  Widget get _progressItem => Center(
        child: CircularProgressIndicator(),
      );

  @override
  Widget build(BuildContext context) {
    return isProcessing ? _progressItem : child;
  }
}
