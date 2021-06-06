import 'dart:io';

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

  Widget getIosPopupButton(BuildContext context) => InkWell(
        onTap: () => _showIosContextMenu(context),
        child: IgnorePointer(child: child),
      );

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid && showCancel) {
      items.add(AppPopupMenuButtonItem(
        text: 'Отмена',
      ));
    }

    return enabled
        ? Platform.isAndroid
            ? _androidPopupButton
            : getIosPopupButton(context)
        : child;
  }

  List<PopupMenuEntry<int>> _contextMenuBuilder(BuildContext context) {
    int index = 0;
    return items
        .map(
          (item) => PopupMenuItem(
            value: index++,
            child: Text(item.text, style: AppTextStyles.bodyText1,),
          ),
        )
        .toList();
  }

  void _showIosContextMenu(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: items
            .map(
              (item) => CupertinoActionSheetAction(
                isDestructiveAction: item.isDestructiveAction,
                child: Text(item.text),
                onPressed: () {
                  Navigator.pop(context);
                  item.onPressed?.call();
                },
              ),
            )
            .toList(),
        cancelButton: showCancel
            ? CupertinoActionSheetAction(
                child: Text('Отмена'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
      ),
    );
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
