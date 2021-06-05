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
          title: 'Список работников',
          showBack: true,
        ),
        body: ServicesModificationForm(),
      );
}

class ServicesModificationPageArgs {
  ServicesModificationPageArgs(this.mode);

  final ServicesModificationMode mode;
}

enum ServicesModificationMode { CONFIRMATION, PAYMENT }
