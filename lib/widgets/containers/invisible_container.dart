import 'package:flutter/material.dart';

///Container that allows to change content visibility.
///As opposed to [Visibility] this container render child with zero opacity, so content takes his place on screen but is invisible for user
class InvisibleContainer extends StatelessWidget {
  const InvisibleContainer({required this.isInvisible, required this.child});

  final bool isInvisible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isInvisible,
      child: Opacity(
        opacity: isInvisible ? 0.0 : 1.0,
        child: child,
      ),
    );
  }
}
