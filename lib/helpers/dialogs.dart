import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, dynamic error) {
  print(error);
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
            backgroundColor: AppColors.secondary,
            title: Text(
              "Ошибка",
              style: TextStyle(color: AppColors.white),
            ),
            content: Text(
              "Что то пошо не так :( \n$error",
              style: TextStyle(color: AppColors.white),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  child: Text(
                    'Закрыть',
                    style: TextStyle(color: AppColors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ));
}

void showDialogMessage(
  BuildContext context, {
  String? message,
  String? title,
  Function? action,
  bool barrierDismissible = true,
}) {
  showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => AlertDialog(
            backgroundColor: AppColors.secondary,
            title: Text(
              title ?? '',
              style: TextStyle(color: AppColors.white),
            ),
            content: Text(
              message ?? '',
              style: TextStyle(color: AppColors.white),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  child: Text(
                    'Oк',
                    style: TextStyle(color: AppColors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    action?.call();
                  },
                ),
              )
            ],
          ));
}
