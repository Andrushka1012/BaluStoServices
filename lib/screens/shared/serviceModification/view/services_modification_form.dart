import 'package:balu_sto/features/firestore/models/employee_status.dart';
import 'package:balu_sto/helpers/dialogs.dart';
import 'package:balu_sto/helpers/pair.dart';
import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:balu_sto/helpers/styles/text_styles.dart';
import 'package:balu_sto/screens/shared/employeesList/bloc/employees_management_bloc.dart';
import 'package:balu_sto/screens/shared/serviceModification/view/services_modification_page.dart';
import 'package:balu_sto/widgets/containers/progress_container.dart';
import 'package:balu_sto/widgets/pages/koin_with_params_page.dart';
import 'package:balu_sto/widgets/service_item.dart';
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
    bloc.add(EmployeesManagementEventInit());
  }

  Widget _getContentItem(BuildContext context, EmployeesListStateDefault state) => ListView(
        children: [
          Container(
            height: 150,
            color: Colors.red,
          ),
          _getSelectAllItem(context, state),
          ...state.statuses.map((employee) => _getEmployeeSection(context, employee, state)),
        ],
      );

  Widget _getSelectAllItem(BuildContext context, EmployeesListStateDefault state) {
    final elements = _args.mode == ServicesModificationMode.CONFIRMATION
        ? state.statuses.expand((status) => status.toConfirmation).toList()
        : state.statuses.expand((status) => status.toPayment).toList();

    return Padding(
      padding: const EdgeInsets.all(Dimens.spanBig),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: Dimens.spanHuge,
            height: Dimens.spanHuge,
            child: Checkbox(
                value: elements.every(
                  (element) => state.selections.firstWhere((selection) => selection.first == element).second,
                ),
                onChanged: (isSelected) {
                  final event = isSelected == true
                      ? EmployeesManagementEventSelect(elements)
                      : EmployeesManagementEventUnselect(elements);
                  context.read<EmployeesManagementBloc>().add(event);
                }),
          ),
          SizedBox(
            width: Dimens.spanBig,
          ),
          Text(
            'Выбрать все',
            style: AppTextStyles.bodyText1,
          )
        ],
      ),
    );
  }

  Widget _getEmployeeSection(BuildContext context, EmployeeStatusModel employee, EmployeesListStateDefault state) {
    final elements = _args.mode == ServicesModificationMode.CONFIRMATION ? employee.toConfirmation : employee.toPayment;

    return elements.isNotEmpty
        ? Theme(
            data: Theme.of(context).copyWith(accentColor: AppColors.white),
            child: ExpansionTile(
              initiallyExpanded: true,
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: Dimens.spanBig),
                    child: SizedBox(
                      width: Dimens.spanHuge,
                      height: Dimens.spanHuge,
                      child: Checkbox(
                        value: elements.every(
                          (element) => state.selections.firstWhere((selection) => selection.first == element).second,
                        ),
                        onChanged: (isSelected) {
                          final event = isSelected == true
                              ? EmployeesManagementEventSelect(elements)
                              : EmployeesManagementEventUnselect(elements);
                          context.read<EmployeesManagementBloc>().add(event);
                        },
                      ),
                    ),
                  ),
                  Text(
                    employee.user.name,
                    style: AppTextStyles.bodyText1,
                  ),
                ],
              ),
              children: elements
                  .map(
                    (service) => Row(
                      children: [
                        SizedBox(
                          width: Dimens.spanBig,
                        ),
                        SizedBox(
                          width: Dimens.spanHuge,
                          height: Dimens.spanHuge,
                          child: Checkbox(
                            value: state.selections.firstWhere((element) => element.first == service).second,
                            onChanged: (isSelected) {
                              final event = isSelected == true
                                  ? EmployeesManagementEventSelect([service])
                                  : EmployeesManagementEventUnselect([service]);
                              context.read<EmployeesManagementBloc>().add(event);
                            },
                          ),
                        ),
                        Expanded(
                          child: ServiceItem(
                            service,
                            showArrow: false,
                            onSelected: (_) {},
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          )
        : Container();
  }

  @override
  Widget buildPage(BuildContext context) => BlocConsumer<EmployeesManagementBloc, EmployeesManagementState>(
        listener: _handleEvents,
        builder: (ctx, EmployeesManagementState state) => ProgressContainer(
          isProcessing: state is EmployeesListStateProcessing,
          child: state is EmployeesListStateDefault ? _getContentItem(ctx, state) : Container(),
        ),
      );

  void _handleEvents(BuildContext context, EmployeesManagementState state) {
    if (state is EmployeesListStateError) {
      showErrorDialog(context, state.error);
    }
  }
}
