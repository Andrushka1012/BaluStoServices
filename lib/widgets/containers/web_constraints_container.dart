import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class WebConstraintsContainer extends StatelessWidget {
  const WebConstraintsContainer({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: kIsWeb
          ? ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: Dimens.webConstraintsMinSize,
                minWidth: Dimens.webConstraintsMinSize,
                maxHeight: Dimens.webConstraintsMaxHeight,
                maxWidth: Dimens.webConstraintsMaxWidth,
              ),
              child: Center(child: child),
            )
          : child,
    );
  }
}
