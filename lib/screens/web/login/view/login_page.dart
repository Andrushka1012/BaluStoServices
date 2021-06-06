import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/screens/mobile/home/view/home_page.dart';
import 'package:balu_sto/screens/shared/login/bloc/login_bloc.dart';
import 'package:balu_sto/screens/web/login/view/login_body.dart';
import 'package:balu_sto/widgets/pages/koin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginWebPage extends KoinPage<LoginBloc> {
  static const PAGE_NAME = 'LoginPage';

  @override
  Widget buildPage(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: BlocListener<LoginBloc, LoginState>(
          listener: _listenEvents,
          child: LoginBody(),
        ),
      );

  void _listenEvents(BuildContext context, LoginState state) {
    if (state is LoginStateLogged) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        HomePage.PAGE_NAME,
        (Route<dynamic> route) => false,
      );
    }
  }
}
