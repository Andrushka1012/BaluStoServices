import 'dart:ui';

import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:flutter/material.dart';

class IntroContainer extends StatelessWidget {
  const IntroContainer({required this.child, this.fullScreen = true});

  final Widget child;
  final bool fullScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(Dimens.spanHuge)),
        image: DecorationImage(
          image: AssetImage('assets/images/into_background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: FractionallySizedBox(
              widthFactor: !fullScreen ? 0.75 : 1,
              heightFactor: !fullScreen ? 0.8 : 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(Dimens.spanSmall),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
