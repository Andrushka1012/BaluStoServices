import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, dynamic error) {
  showDialog(
      context: context,
      builder: (_) => new AlertDialog(
            title: new Text("Ошибка"),
            content: new Text("Что то пошо не так :( \n$error"),
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


void showDialogMessage(BuildContext context, {String? message, String? title}) {
  showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text(title ?? ''),
        content: new Text(message ?? ''),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              child: Text('Oк'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ));
}

