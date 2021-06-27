import 'package:balu_sto/helpers/dialogs.dart';
import 'package:balu_sto/screens/shared/home/transactionsList/bloc/transactions_list_bloc.dart';
import 'package:balu_sto/widgets/containers/progress_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionsListForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionsListBloc, TransactionsListState>(
      listener: _handleEvents,
      buildWhen: (_, current) => current is TransactionsListStateProcessing || current is TransactionsListStateDefault,
      builder: (_, TransactionsListState state) => ProgressContainer(
        isProcessing: state is TransactionsListStateProcessing,
        child: state is TransactionsListStateDefault ? Container() : Container(),
      ),
    );
  }

  void _handleEvents(BuildContext context, TransactionsListState state) {
    if (state is TransactionsListStateError) {
      showErrorDialog(context, state.error);
    }
  }
}
