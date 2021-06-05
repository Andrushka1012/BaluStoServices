import 'package:balu_sto/features/firestore/models/employee_status.dart';
import 'package:balu_sto/helpers/dialogs.dart';
import 'package:balu_sto/screens/shared/employeesList/bloc/employees_list_bloc.dart';
import 'package:balu_sto/widgets/containers/progress_container.dart';
import 'package:balu_sto/widgets/employee_item.dart';
import 'package:balu_sto/widgets/pages/koin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeesListForm extends KoinPage<EmployeesListBloc> {
  static const PAGE_NAME = 'EmployeesListPage';

  @override
  void initBloc(EmployeesListBloc bloc) {
    bloc.add(EmployeesListEvent.INIT);
  }

  Widget _getContentItem(BuildContext context, List<EmployeeStatusModel> employee) => ListView(
    children: employee
        .map(
          (employee) => EmployeeItem(employee),
    )
        .toList(),
  );

  @override
  Widget buildPage(BuildContext context) => BlocConsumer<EmployeesListBloc, EmployeesListState>(
    listener: _handleEvents,
    builder: (_, EmployeesListState state) => ProgressContainer(
      isProcessing: state is EmployeesListStateProcessing,
      child: state is EmployeesListStateDefault ? _getContentItem(context, state.statuses) : Container(),
    ),
  );

  void _handleEvents(BuildContext context, EmployeesListState state) {
    if (state is EmployeesListStateError) {
      showErrorDialog(context, state.error);
    }
  }
}