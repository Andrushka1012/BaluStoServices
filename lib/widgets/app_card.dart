import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding = const EdgeInsets.all(Dimens.spanBig),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.all(Dimens.spanSmall),
        child: Padding(
          padding: padding,
          child: child,
        ),
      );
}
