import 'package:balu_sto/screens/mobile/home/view/home_page.dart';
import 'package:balu_sto/screens/mobile/registration/view/registration_page.dart';
import 'package:balu_sto/screens/shared/login/bloc/login_bloc.dart';
import 'package:balu_sto/screens/shared/login/view/login_form.dart';
import 'package:balu_sto/widgets/pages/koin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends KoinPage<LoginBloc> {
  static const PAGE_NAME = 'LoginPage';

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: _listenEvents,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8
                ),
                child: Center(child: LoginForm()),
              ),
              Center(
                child: ElevatedButton(
                  child: Text('Создать аккаунт'),
                  onPressed: () => Navigator.of(context).pushNamed(RegistrationPage.PAGE_NAME),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _listenEvents(BuildContext context, LoginState state) {
    if (state is LoginStateLogged) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        HomePage.PAGE_NAME,
        (Route<dynamic> route) => false,
      );
    }
  }
}
