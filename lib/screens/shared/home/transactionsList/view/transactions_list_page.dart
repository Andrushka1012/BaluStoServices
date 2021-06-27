import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/screens/shared/home/transactionsList/bloc/transactions_list_bloc.dart';
import 'package:balu_sto/screens/shared/home/transactionsList/view/transactions_list_form.dart';
import 'package:balu_sto/widgets/balu_appbar.dart';
import 'package:balu_sto/widgets/pages/koin_with_params_page.dart';
import 'package:flutter/material.dart';

class TransactionsListPage extends KoinWithParamsPage<TransactionsListBloc, String?> {
  static const PAGE_NAME = 'TransactionsListPage';

  @override
  String? get params => null;

  @override
  void initBloc(TransactionsListBloc bloc) {
    bloc.add(TransactionsListEvent.INIT);
  }

  @override
  Widget buildPage(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: BaluAppbar(
          title: 'Список трансакций',
          showBack: true,
        ),
        body: TransactionsListForm(),
      );
}
