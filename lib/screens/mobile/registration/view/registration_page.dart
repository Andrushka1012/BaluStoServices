import 'package:balu_sto/screens/mobile/home/view/home_page.dart';
import 'package:balu_sto/screens/shared/registration/bloc/registration_bloc.dart';
import 'package:balu_sto/screens/shared/registration/view/registraton_form.dart';
import 'package:balu_sto/widgets/pages/koin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationPage extends KoinPage<RegistrationBloc> {
  static const PAGE_NAME = 'RegistrationPage';

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: BlocListener<RegistrationBloc, RegistrationState>(
        listener: _listenEvents,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Center(child: RegistrationForm()),
        ),
      ),
    );
  }

  void _listenEvents(BuildContext context, RegistrationState state) {
    if (state is RegistrationStateLogged) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        HomePage.PAGE_NAME,
        (Route<dynamic> route) => false,
      );
    }
  }
}
