import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class WebLimitationContainer extends StatelessWidget {
  const WebLimitationContainer({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: kIsWeb
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: Dimens.webConstraintsMinSize,
                    ),
                    child: Center(child: child),
                  ),
                ),
              ],
            )
          : child,
    );
  }
}
