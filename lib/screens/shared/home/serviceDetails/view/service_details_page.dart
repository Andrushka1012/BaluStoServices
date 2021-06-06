import 'package:balu_sto/features/firestore/models/service.dart';
import 'package:balu_sto/widgets/balu_appbar.dart';
import 'package:flutter/material.dart';

class ServiceDetailsPage extends StatelessWidget {
  static const PAGE_NAME = 'ServiceDetailsPage';

  ServiceDetailsPage(this._args);

  final ServiceDetailsPageArgs _args;

  static getPageName(String userId, String serviceId) => 'user/$userId/$serviceId/$PAGE_NAME';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaluAppbar(
        title: _args.service.serviceName,
        showBack: true,
      ),
    );
  }
}

class ServiceDetailsPageArgs {
  ServiceDetailsPageArgs(this.service);
  final Service service;
}
