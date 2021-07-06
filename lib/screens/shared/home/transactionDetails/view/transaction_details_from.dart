import 'package:balu_sto/features/firestore/models/service.dart';
import 'package:balu_sto/features/firestore/models/service_status.dart';
import 'package:balu_sto/features/firestore/models/user.dart';
import 'package:balu_sto/helpers/dialogs.dart';
import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:balu_sto/helpers/styles/text_styles.dart';
import 'package:balu_sto/screens/shared/home/transactionDetails/bloc/transaction_details_bloc.dart';
import 'package:balu_sto/widgets/app_card.dart';
import 'package:balu_sto/widgets/containers/progress_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionDetailsFrom extends StatelessWidget {
  Widget _getSummaryItem(BuildContext context, TransactionDetailsStateDefault state) => AppCard(
        child: Column(
          children: [
            Text(
              state.details.transaction.status == ServiceStatus.CONFIRMED ? 'Принято' : 'Оплаченно',
              style: AppTextStyles.bodyText1.copyWith(color: AppColors.gray),
            ),
            _getModeAmountItem(state),
            ...state.details.relatedUsers.map((user) => _getUserSummaryItem(state, user)).toList()
          ],
        ),
      );

  Widget _getUserSummaryItem(TransactionDetailsStateDefault state, AppUser user) => Padding(
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
                    user.name,
                    style: AppTextStyles.bodyText1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  _getUserSummaryStatisticItem(
                      state, state.details.relatedServices.where((service) => service.userId == user.userId).toList()),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _getUserSummaryStatisticItem(TransactionDetailsStateDefault state, List<Service> userSummary) =>
      state.details.transaction.status == ServiceStatus.CONFIRMED
          ? Text(
              'принято: ${userSummary.fold(0, (int previousValue, element) => previousValue + element.moneyAmount)}  количество услуг: ${userSummary.length}',
              style: TextStyle(color: AppColors.gray, fontSize: Dimens.fontSizeCaption),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : Text(
              'выданно: ${userSummary.fold(0, (int previousValue, element) => previousValue + element.moneyAmount) / 2} прийнято: ${userSummary.fold(0, (int previousValue, element) => previousValue + element.moneyAmount)} количество услуг: ${userSummary.length}',
              style: TextStyle(color: AppColors.gray, fontSize: Dimens.fontSizeCaption),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );

  Widget _getModeAmountItem(TransactionDetailsStateDefault state) =>
      state.details.transaction.status == ServiceStatus.CONFIRMED
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  state.details.selectedAmount.toString(),
                  style: AppTextStyles.headline0,
                ),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Прийнято:',
                  style: AppTextStyles.bodyText1.copyWith(color: AppColors.gray),
                ),
                SizedBox(
                  width: Dimens.spanSmall,
                ),
                Text(
                  state.details.selectedAmount.toString(),
                  style: AppTextStyles.headline0,
                ),
                SizedBox(
                  width: Dimens.spanBig,
                ),
                Text(
                  'Выплаченно:',
                  style: AppTextStyles.bodyText1.copyWith(color: AppColors.gray),
                ),
                SizedBox(
                  width: Dimens.spanSmall,
                ),
                Text(
                  (state.details.selectedAmount / 2).toString(),
                  style: AppTextStyles.headline0,
                ),
              ],
            );

  Widget _getTransactionDetailer(BuildContext context, TransactionDetailsStateDefault state) => SingleChildScrollView(
        child: Column(
          children: [
            _getSummaryItem(context, state),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionDetailsBloc, TransactionDetailsState>(
      listener: _handleEvents,
      buildWhen: (_, current) =>
          current is TransactionDetailsStateProcessing || current is TransactionDetailsStateDefault,
      builder: (_, state) => ProgressContainer(
        isProcessing: state is TransactionDetailsStateProcessing,
        child: state is TransactionDetailsStateDefault ? _getTransactionDetailer(context, state) : Container(),
      ),
    );
  }

  void _handleEvents(BuildContext context, TransactionDetailsState state) {
    if (state is TransactionDetailsStateError) {
      showErrorDialog(context, state.error);
    }
  }
}
