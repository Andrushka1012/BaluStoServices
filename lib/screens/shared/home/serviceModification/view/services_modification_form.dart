import 'package:balu_sto/features/firestore/models/employee_status.dart';
import 'package:balu_sto/features/firestore/models/service.dart';
import 'package:balu_sto/features/firestore/models/user.dart';
import 'package:balu_sto/helpers/dialogs.dart';
import 'package:balu_sto/helpers/extensions/list_extensions.dart';
import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:balu_sto/helpers/styles/text_styles.dart';
import 'package:balu_sto/screens/shared/home/employeesList/bloc/employees_management_bloc.dart';
import 'package:balu_sto/screens/shared/home/serviceDetails/view/service_details_page.dart';
import 'package:balu_sto/screens/shared/home/serviceModification/view/services_modification_page.dart';
import 'package:balu_sto/widgets/app_card.dart';
import 'package:balu_sto/widgets/containers/progress_container.dart';
import 'package:balu_sto/widgets/service_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServicesModificationForm extends StatelessWidget {
  ServicesModificationForm(this._args);

  final ServicesModificationPageArgs _args;

  Widget get _emptyItem => Center(
        child: Column(
          children: [
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/into_background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              'Все чисто',
              style: AppTextStyles.headline1,
            ),
          ],
        ),
      );

  Widget _getContentItem(BuildContext context, EmployeesListStateDefault state) =>
      state.filterServicesBy(_args.mode).isNotEmpty
          ? ListView(
              children: [
                _getSummaryItem(state),
                _getSelectAllItem(context, state),
                ...state.statuses.map((employee) => _getEmployeeSection(context, employee, state)),
              ],
            )
          : _emptyItem;

  Widget _getSummaryItem(EmployeesListStateDefault state) => AppCard(
          child: Column(
        children: [
          Text(
            _args.mode == ServicesModificationMode.CONFIRMATION ? 'К принятию' : 'К выдаче',
            style: AppTextStyles.bodyText1.copyWith(color: AppColors.gray),
          ),
          _getModeAmountItem(state),
          ...state.selectedSelections
              .groupBy((triple) => triple.third)
              .map((key, value) => MapEntry(key, value.map((triple) => triple.first).toList()))
              .entries
              .map(_getUserSummaryItem)
              .toList(),
        ],
      ));

  Widget _getModeAmountItem(EmployeesListStateDefault state) => _args.mode == ServicesModificationMode.CONFIRMATION
      ? Text(
          state.selectedAmount.toString(),
          style: AppTextStyles.headline0,
        )
      : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Прийнято:',
              style: AppTextStyles.bodyText1.copyWith(color: AppColors.gray),
            ),
            SizedBox(
              width: Dimens.spanSmall,
            ),
            Text(
              state.selectedAmount.toString(),
              style: AppTextStyles.headline0,
            ),
            SizedBox(
              width: Dimens.spanBig,
            ),
            Text(
              'Выдать:',
              style: AppTextStyles.bodyText1.copyWith(color: AppColors.gray),
            ),
            SizedBox(
              width: Dimens.spanSmall,
            ),
            Text(
              (state.selectedAmount / 2).toString(),
              style: AppTextStyles.headline0,
            ),
          ],
        );

  Widget _getUserSummaryItem(MapEntry<AppUser, List<Service>> userSummary) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimens.spanSmall),
        child: Row(
          children: [
            Container(
              width: Dimens.spanLarge,
              height: Dimens.spanLarge,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.all(
                  Radius.circular(100),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.person,
                  size: Dimens.spanHuge,
                  color: AppColors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: Dimens.spanMedium, right: Dimens.spanHuge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userSummary.key.name,
                    style: AppTextStyles.bodyText1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  _getUserSummaryStatisticItem(userSummary),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _getUserSummaryStatisticItem(MapEntry<AppUser, List<Service>> userSummary) =>
      _args.mode == ServicesModificationMode.CONFIRMATION
          ? Text(
              'прийнять: ${userSummary.value.fold(0, (int previousValue, element) => previousValue + element.moneyAmount)}  количество услуг: ${userSummary.value.length}',
              style: TextStyle(color: AppColors.gray, fontSize: Dimens.fontSizeCaption),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : Text(
              'выдать: ${userSummary.value.fold(0, (int previousValue, element) => previousValue + element.moneyAmount) / 2} прийнято: ${userSummary.value.fold(0, (int previousValue, element) => previousValue + element.moneyAmount)} количество услуг: ${userSummary.value.length}',
              style: TextStyle(color: AppColors.gray, fontSize: Dimens.fontSizeCaption),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );

  Widget _getSelectAllItem(BuildContext context, EmployeesListStateDefault state) {
    final elements = state.filterServicesBy(_args.mode);

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
                            onSelected: (service) => Navigator.of(context).pushNamed(
                              ServiceDetailsPage.getPageName(service.userId, service.id),
                              arguments: ServiceDetailsPageArgs(
                                service,
                              ),
                            ),
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
  Widget build(BuildContext context) => BlocConsumer<EmployeesManagementBloc, EmployeesManagementState>(
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

    if (state is EmployeesListStateSuccess) {
      Navigator.of(context).pop();
      // TODO: open transaction details
    }
  }
}
