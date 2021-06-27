import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/screens/shared/home/transactionsList/view/transactions_list_form.dart';
import 'package:balu_sto/widgets/balu_appbar.dart';
import 'package:flutter/material.dart';

class TransactionsListPage extends StatelessWidget {
  static const PAGE_NAME = 'TransactionsListPage';

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: BaluAppbar(
          title: 'Список трансакций',
          showBack: true,
        ),
        body: SingleChildScrollView(
          child: TransactionsListForm(
            userId: null,
          ),
        ),
      );
}
