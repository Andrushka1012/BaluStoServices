import 'package:balu_sto/features/firestore/models/transaction.dart';
import 'package:balu_sto/helpers/extensions/date_extensions.dart';
import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/screens/shared/home/transactionDetails/bloc/transaction_details_bloc.dart';
import 'package:balu_sto/screens/shared/home/transactionDetails/view/transaction_details_from.dart';
import 'package:balu_sto/widgets/balu_appbar.dart';
import 'package:balu_sto/widgets/pages/koin_page.dart';
import 'package:balu_sto/widgets/pages/koin_with_params_page.dart';
import 'package:flutter/material.dart';

class TransactionDetailsPage extends KoinWithParamsPage<TransactionDetailsBloc, String> {
  static const PAGE_NAME = 'TransactionDetailsPage';

  TransactionDetailsPage(this._args);

  final TransactionDetailsPageArgs _args;

  @override
  String get params => _args.transaction.id;

  @override
  void initBloc(TransactionDetailsBloc bloc) {
    bloc.add(TransactionDetailsEvent.INIT);
  }

  @override
  Widget buildPage(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: BaluAppbar(
          title: 'Транзакция от ${_args.transaction.date.formatted()}',
          showBack: true,
        ),
        body: TransactionDetailsFrom(),
      );

}

class TransactionDetailsPageArgs {
  const TransactionDetailsPageArgs(this.transaction);

  final WorkTransaction transaction;
}
