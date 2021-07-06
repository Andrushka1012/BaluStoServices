import 'package:balu_sto/helpers/dialogs.dart';
import 'package:balu_sto/screens/shared/home/transactionDetails/bloc/transaction_details_bloc.dart';
import 'package:balu_sto/widgets/app_card.dart';
import 'package:balu_sto/widgets/containers/progress_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionDetailsFrom extends StatelessWidget {
  Widget _getTransactionDetailer(BuildContext context, TransactionDetailsStateDefault state) => AppCard(
        child: Column(
          children: [

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
