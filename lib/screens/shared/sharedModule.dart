import 'package:balu_sto/screens/shared/login/bloc/login_bloc.dart';
import 'package:balu_sto/screens/shared/registration/bloc/registration_bloc.dart';
import 'package:koin/koin.dart';

final sharedModule = Module()
  ..factory((scope) => LoginBloc(scope.get(), scope.get()))
  ..factory((scope) => RegistrationBloc(scope.get(), scope.get()));
