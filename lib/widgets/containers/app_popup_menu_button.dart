import 'package:balu_sto/helpers/styles/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppPopupMenuButton extends StatelessWidget {
  const AppPopupMenuButton({
    required this.child,
    required this.items,
    this.showCancel = false,
    this.enabled = true,
  });

  final Widget child;
  final List<AppPopupMenuButtonItem> items;
  final bool showCancel;
  final bool enabled;

  Widget get _androidPopupButton => PopupMenuButton<int>(
        child: IgnorePointer(
          ignoring: true,
          child: child,
        ),
        itemBuilder: _contextMenuBuilder,
        onSelected: (index) => items[index].onPressed?.call(),
      );

  @override
  Widget build(BuildContext context) {
    return _androidPopupButton;
  }

  List<PopupMenuEntry<int>> _contextMenuBuilder(BuildContext context) {
    int index = 0;
    return items
        .map(
          (item) => PopupMenuItem(
            value: index++,
            child: Text(
              item.text,
              style: AppTextStyles.bodyText1,
            ),
          ),
        )
        .toList();
  }
}

class AppPopupMenuButtonItem {
  const AppPopupMenuButtonItem({
    required this.text,
    this.onPressed,
    this.isDestructiveAction = false,
  });

  final String text;
  final Function? onPressed;
  final bool isDestructiveAction;
}
