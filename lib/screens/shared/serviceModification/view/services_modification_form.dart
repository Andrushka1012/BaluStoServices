import 'package:balu_sto/features/firestore/models/employee_status.dart';
import 'package:balu_sto/helpers/dialogs.dart';
import 'package:balu_sto/helpers/pair.dart';
import 'package:balu_sto/screens/shared/employeesList/bloc/employees_management_bloc.dart';
import 'package:balu_sto/screens/shared/serviceModification/view/services_modification_page.dart';
import 'package:balu_sto/widgets/containers/progress_container.dart';
import 'package:balu_sto/widgets/pages/koin_with_params_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServicesModificationForm
    extends KoinWithParamsPage<EmployeesManagementBloc, Pair<String?, ServicesModificationMode?>> {
  ServicesModificationForm(this._args);

  final ServicesModificationPageArgs _args;

  @override
  Pair<String?, ServicesModificationMode?> get params => Pair(_args.userId, _args.mode);

  @override
  void initBloc(EmployeesManagementBloc bloc) {
    bloc.add(EmployeesManagementEvent.INIT);
  }

  Widget _getContentItem(BuildContext context, List<EmployeeStatusModel> employee) => ListView();

  @override
  Widget buildPage(BuildContext context) => BlocConsumer<EmployeesManagementBloc, EmployeesManagementState>(
        listener: _handleEvents,
        builder: (_, EmployeesManagementState state) => ProgressContainer(
          isProcessing: state is EmployeesListStateProcessing,
          child: state is EmployeesListStateDefault ? _getContentItem(context, state.statuses) : Container(),
        ),
      );

  void _handleEvents(BuildContext context, EmployeesManagementState state) {
    if (state is EmployeesListStateError) {
      showErrorDialog(context, state.error);
    }
  }
}
