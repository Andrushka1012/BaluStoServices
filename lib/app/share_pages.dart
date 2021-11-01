import 'package:balu_sto/screens/shared/home/employeesList/view/employees_list_page.dart';
import 'package:balu_sto/screens/shared/home/serviceDetails/view/service_details_page.dart';
import 'package:balu_sto/screens/shared/home/serviceModification/view/services_modification_page.dart';
import 'package:balu_sto/screens/shared/home/servicesList/view/services_list_page.dart';
import 'package:balu_sto/screens/shared/home/statistic/view/statistic_page.dart';
import 'package:balu_sto/screens/shared/home/transactionDetails/view/transaction_details_page.dart';
import 'package:balu_sto/screens/shared/home/transactionsList/view/transactions_list_page.dart';
import 'package:balu_sto/screens/shared/home/userPage/view/user_profile_page.dart';
import 'package:flutter/material.dart';

final Widget Function(RouteSettings) getGenerateSharedRoutePage = (RouteSettings settings) {
  if (settings.name == EmployeesListPage.PAGE_NAME) return EmployeesListPage();

  if (settings.name!.contains(ServicesListPage.PAGE_NAME)) {
    return ServicesListPage(
      settings.arguments != null
          ? settings.arguments as ServicesListPageArgs
          : ServicesListPageArgs(
              userId: settings.name!.split('/')[1],
            ),
    );
  }

  if (settings.name!.contains(UserProfilePage.PAGE_NAME)) {
    return UserProfilePage(
      settings.arguments != null
          ? settings.arguments as UserProfilePageArg
          : UserProfilePageArg(
              userId: settings.name!.split('/')[1],
            ),
    );
  }
  if (settings.name!.contains(TransactionDetailsPage.PAGE_NAME)) {
    return TransactionDetailsPage(settings.arguments as TransactionDetailsPageArgs);
  }

  if (settings.name!.contains(ServiceDetailsPage.PAGE_NAME)) {
    return ServiceDetailsPage(settings.arguments as ServiceDetailsPageArgs);
  }

  if (settings.name!.contains(ServicesModificationPage.PAGE_NAME)) {
    return ServicesModificationPage(settings.arguments as ServicesModificationPageArgs);
  }
  if (settings.name!.contains(TransactionsListPage.PAGE_NAME)) {
    return TransactionsListPage();
  }

  if (settings.name!.contains(StatisticPage.PAGE_NAME)) {
    return StatisticPage(settings.arguments as StatisticPageArgs);
  }

  throw Exception('Not screen specified to route ${settings.name}');
};
