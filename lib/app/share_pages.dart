import 'package:balu_sto/screens/shared/employeesList/view/employees_list_page.dart';
import 'package:balu_sto/screens/shared/home/servicesList/view/services_list_page.dart';
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

  throw Exception('Not screen specified to route ${settings.name}');
};
