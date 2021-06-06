import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:balu_sto/helpers/styles/text_styles.dart';
import 'package:flutter/material.dart';

class BaluAppbar extends StatelessWidget implements PreferredSizeWidget {
  const BaluAppbar({
    required this.title,
    this.showBack = false,
    this.defaultLeading = false,
    this.actions = const [],
  });

  final String title;
  final bool showBack;
  final bool defaultLeading;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) => AppBar(
        backgroundColor: AppColors.secondary,
        brightness: Brightness.dark,
        elevation: 0,
        centerTitle: true,
        leading: defaultLeading
            ? null
            : showBack
                ? IconButton(
                    icon: Icon(
                      Icons.chevron_left,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                : Container(),
        title: Text(
          title,
          style: AppTextStyles.bodyText2w500.copyWith(
            fontSize: Dimens.fontSizeHeadline2,
          ),
        ),
        actions: actions,
      );

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
