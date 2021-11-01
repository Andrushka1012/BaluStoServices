import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/screens/shared/home/statistic/bloc/statistic_bloc.dart';
import 'package:balu_sto/screens/shared/home/statistic/view/statistic_form.dart';
import 'package:balu_sto/widgets/balu_appbar.dart';
import 'package:balu_sto/widgets/containers/web_constraints_container.dart';
import 'package:balu_sto/widgets/pages/koin_with_params_page.dart';
import 'package:flutter/material.dart';

class StatisticPage extends KoinWithParamsPage<StatisticBloc, String?> {
  static const PAGE_NAME = 'StatisticPage';

  StatisticPage(this._args);

  final StatisticPageArgs _args;

  @override
  String? get params => _args.userId;

  @override
  void initBloc(StatisticBloc bloc) {
    bloc.init();
  }

  @override
  Widget buildPage(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: BaluAppbar(
          title: 'Статистика',
          showBack: true,
        ),
        body: SafeArea(
          child: WebConstraintsContainer(
            child: StatisticForm(),
            smallScreen: true,
          ),
        ),
      );
}

class StatisticPageArgs {
  StatisticPageArgs({this.userId});

  final String? userId;
}
