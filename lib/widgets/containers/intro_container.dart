import 'dart:ui';

import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:flutter/material.dart';

class IntroContainer extends StatelessWidget {
  const IntroContainer({required this.child});

  final Widget child;

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
              widthFactor: 0.75,
              heightFactor: 0.8,
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
