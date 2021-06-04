import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, dynamic error) {
  print(error);
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
            title: Text("Ошибка"),
            content: Text("Что то пошо не так :( \n$error"),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  child: Text('Закрыть'),
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
            title: Text(title ?? ''),
            content: Text(message ?? ''),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  child: Text('Oк'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    action?.call();
                  },
                ),
              )
            ],
          ));
}
