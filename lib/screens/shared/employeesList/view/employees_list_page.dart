import 'package:balu_sto/helpers/dialogs.dart';
import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/screens/shared/employeesList/bloc/employees_list_bloc.dart';
import 'package:balu_sto/screens/shared/employeesList/view/employees_list_form.dart';
import 'package:balu_sto/widgets/balu_appbar.dart';
import 'package:flutter/material.dart';

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

  void _handleEvents(BuildContext context, EmployeesListState state) {
    if (state is EmployeesListStateError) {
      showErrorDialog(context, state.error);
    }
  }
}