import 'package:balu_sto/features/firestore/models/service.dart';
import 'package:balu_sto/helpers/pair.dart';
import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/screens/mobile/service/service/service_bloc.dart';
import 'package:balu_sto/screens/mobile/service/view/service_form.dart';
import 'package:balu_sto/widgets/balu_appbar.dart';
import 'package:balu_sto/widgets/containers/web_constraints_container.dart';
import 'package:balu_sto/widgets/pages/koin_with_params_page.dart';
import 'package:flutter/material.dart';

class ServicePage extends KoinWithParamsPage<ServiceBloc, Pair<Service?, bool>> {
  static const PAGE_NAME = 'ServicePage';

  ServicePage(this._args);

  final ServicePageArgs _args;

  @override
  Pair<Service?, bool> get params => Pair(_args.service, _args.editMode);

  @override
  Widget buildPage(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: BaluAppbar(
          title: !_args.editMode ? 'Добавить услугу' : 'Редактировать услугу',
          showBack: true,
        ),
        body: SafeArea(
          child: WebConstraintsContainer(
            child: ServiceForm(),
            smallScreen: true,
          ),
        ),
      );
}

class ServicePageArgs {
  const ServicePageArgs({this.service, this.editMode = false});

  final Service? service;
  final bool editMode;
}
