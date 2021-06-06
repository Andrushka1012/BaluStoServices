import 'package:balu_sto/features/firestore/firestore_repository.dart';
import 'package:balu_sto/helpers/pair.dart';
import 'package:balu_sto/screens/shared/login/bloc/login_bloc.dart';
import 'package:balu_sto/screens/shared/registration/bloc/registration_bloc.dart';
import 'package:balu_sto/screens/shared/serviceModification/view/services_modification_page.dart';
import 'package:balu_sto/screens/shared/splashScreen/bloc/splash_screen_bloc.dart';
import 'package:koin/koin.dart';

import 'employeesList/bloc/employees_management_bloc.dart';
import 'home/servicesList/bloc/services_list_bloc.dart';
import 'home/userServices/bloc/user_services_bloc.dart';

final sharedModule = Module()
  ..factory((scope) => SplashScreenBloc(
        scope.get(),
        scope.get(),
        scope.get(),
      ))
  ..factory((scope) => LoginBloc(scope.get(), scope.get()))
  ..factory((scope) => RegistrationBloc(scope.get(), scope.get(), scope.get()))
  ..factoryWithParam<RecentServicesBloc, String>((scope, String arg) => RecentServicesBloc(arg, scope.get()))
  ..factoryWithParam<ServicesListBloc, String>((scope, String args) => ServicesListBloc(
        args,
        scope.get<FirestoreRepository>(),
      ))
  ..factoryWithParam<EmployeesManagementBloc, Pair<String?, ServicesModificationMode?>>(
    (scope, Pair<String?, ServicesModificationMode?> args) => EmployeesManagementBloc(
      firestoreRepository: scope.get(),
      userId: args.first,
      mode: args.second,
    ),
  );
