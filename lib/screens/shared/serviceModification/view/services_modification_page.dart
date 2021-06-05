import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/screens/shared/serviceModification/view/services_modification_form.dart';
import 'package:balu_sto/widgets/balu_appbar.dart';
import 'package:flutter/material.dart';

class ServicesModificationPage extends StatelessWidget {
  static const PAGE_NAME = 'ServicesModificationPage';

  ServicesModificationPage(this._args);

  final ServicesModificationPageArgs _args;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: BaluAppbar(
          title: _args.mode == ServicesModificationMode.CONFIRMATION ? 'Прийнять оплату' : 'Выдать зарплату',
          showBack: true,
        ),
        body: ServicesModificationForm(_args),
      );
}

class ServicesModificationPageArgs {
  ServicesModificationPageArgs({
    required this.mode,
    this.userId,
  });

  final ServicesModificationMode mode;
  final String? userId;
}

enum ServicesModificationMode { CONFIRMATION, PAYMENT }
