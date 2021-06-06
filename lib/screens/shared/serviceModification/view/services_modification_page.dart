import 'package:balu_sto/helpers/pair.dart';
import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/screens/shared/employeesList/bloc/employees_management_bloc.dart';
import 'package:balu_sto/screens/shared/serviceModification/view/services_modification_form.dart';
import 'package:balu_sto/widgets/balu_appbar.dart';
import 'package:balu_sto/widgets/pages/koin_with_params_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServicesModificationPage
    extends KoinWithParamsPage<EmployeesManagementBloc, Pair<String?, ServicesModificationMode?>> {
  static const PAGE_NAME = 'ServicesModificationPage';

  ServicesModificationPage(this._args);

  final ServicesModificationPageArgs _args;

  @override
  Pair<String?, ServicesModificationMode?> get params => Pair(_args.userId, _args.mode);

  String get _title => _args.mode == ServicesModificationMode.CONFIRMATION ? 'Прийнять оплату' : 'Выдать зарплату';

  @override
  void initBloc(EmployeesManagementBloc bloc) {
    bloc.add(EmployeesManagementEventInit());
  }

  @override
  Widget buildPage(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: BaluAppbar(
          title: _title,
          showBack: true,
        ),
        body: ServicesModificationForm(_args),
        floatingActionButton: BlocBuilder<EmployeesManagementBloc, EmployeesManagementState>(
            builder: (ctx, EmployeesManagementState state) {
          return state is EmployeesListStateDefault
              ? FloatingActionButton(
                  onPressed: state.selectedSelections.isNotEmpty ? () => _onAction(ctx, state) : null,
                  backgroundColor: AppColors.secondary,
                  child: Icon(
                    _args.mode == ServicesModificationMode.CONFIRMATION
                        ? Icons.arrow_downward_outlined
                        : Icons.arrow_upward_outlined,
                    color: AppColors.primary,
                  ),
                )
              : Container();
        }),
      );

  void _onAction(BuildContext context, EmployeesListStateDefault state) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: AppColors.secondary,
              title: Text(
                _title,
                style: TextStyle(color: AppColors.white),
              ),
              content: Text(
                'Вы уверенны что хотите $_title в общем размере ${_args.mode == ServicesModificationMode.CONFIRMATION ? state.selectedAmount : state.selectedAmount / 2}?',
                style: TextStyle(color: AppColors.white),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    child: Text(
                      'Да',
                      style: TextStyle(color: AppColors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.read<EmployeesManagementBloc>().add(EmployeesManagementEventApply());
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    child: Text(
                      'Нет',
                      style: TextStyle(color: AppColors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ));
  }
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
