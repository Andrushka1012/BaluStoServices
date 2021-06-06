import 'package:balu_sto/screens/shared/employeesList/view/employees_list_page.dart';
import 'package:balu_sto/screens/shared/home/servicesList/view/services_list_page.dart';
import 'package:balu_sto/screens/shared/home/userPage/view/user_profile_page.dart';
import 'package:balu_sto/screens/shared/serviceModification/view/services_modification_page.dart';
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
  if (settings.name!.contains(ServicesModificationPage.PAGE_NAME)) {
    return ServicesModificationPage(settings.arguments as ServicesModificationPageArgs);
  }

  throw Exception('Not screen specified to route ${settings.name}');
};
