import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class WebConstraintsContainer extends StatelessWidget {
  const WebConstraintsContainer({
    required this.child,
    this.smallScreen = false,
  });

  final Widget child;
  final bool smallScreen;

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? Center(
          child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: Dimens.webConstraintsMinSize,
                minWidth: smallScreen ? Dimens.webConstraintsMinSize / 2 : Dimens.webConstraintsMinSize,
                maxHeight: Dimens.webConstraintsMaxHeight,
                maxWidth: smallScreen ? Dimens.webConstraintsMaxWidth / 2 : Dimens.webConstraintsMaxWidth,
              ),
              child: Center(child: child),
            ),
        )
        : child;
  }
}
