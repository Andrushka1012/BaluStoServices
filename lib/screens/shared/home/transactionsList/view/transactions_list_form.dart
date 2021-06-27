import 'package:balu_sto/helpers/dialogs.dart';
import 'package:balu_sto/screens/shared/home/transactionsList/bloc/transactions_list_bloc.dart';
import 'package:balu_sto/widgets/containers/progress_container.dart';
import 'package:balu_sto/widgets/pages/koin_with_params_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionsListForm extends KoinWithParamsPage<TransactionsListBloc, String?> {
  TransactionsListForm({required this.userId});

  final String? userId;

  @override
  String? get params => userId;

  @override
  void initBloc(TransactionsListBloc bloc) {
    bloc.add(TransactionsListEvent.INIT);
  }

  Widget _getTransactionsItems(BuildContext context, TransactionsListStateDefault state) => Column(
        children: state.transactions.map((e) => Text(e.id)).toList(),
      );

  @override
  Widget buildPage(BuildContext context) {
    return BlocConsumer<TransactionsListBloc, TransactionsListState>(
      listener: _handleEvents,
      buildWhen: (_, current) => current is TransactionsListStateProcessing || current is TransactionsListStateDefault,
      builder: (_, TransactionsListState state) => ProgressContainer(
        isProcessing: state is TransactionsListStateProcessing,
        child: state is TransactionsListStateDefault ? _getTransactionsItems(context, state) : Container(),
      ),
    );
  }

  void _handleEvents(BuildContext context, TransactionsListState state) {
    if (state is TransactionsListStateError) {
      showErrorDialog(context, state.error);
    }
  }
}
