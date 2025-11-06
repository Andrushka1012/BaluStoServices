import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, dynamic error) {
  final errorMessage = error?.toString() ?? 'Unknown error';
  print('=== ERROR DIALOG ===');
  print(errorMessage);
  print('===================');

  showDialog(
      context: context,
      builder: (_) => AlertDialog(
            backgroundColor: AppColors.secondary,
            title: Row(
              children: [
                Icon(Icons.error_outline, color: AppColors.redTart),
                SizedBox(width: 8),
                Text(
                  "Error",
                  style: TextStyle(
                      color: AppColors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: SelectableText(
                errorMessage,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  child: Text(
                    'Close',
                    style: TextStyle(
                        color: AppColors.white, fontWeight: FontWeight.bold),
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
