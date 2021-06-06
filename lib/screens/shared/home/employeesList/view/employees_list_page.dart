import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/widgets/balu_appbar.dart';
import 'package:flutter/material.dart';

import 'employees_list_form.dart';

class EmployeesListPage extends StatelessWidget {
  static const PAGE_NAME = 'EmployeesListPage';

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: BaluAppbar(
          title: 'Список работников',
          showBack: true,
        ),
        body: EmployeesListForm(),
      );
}
