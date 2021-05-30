import 'package:balu_sto/screens/mobile/login/view/login_page.dart';
import 'package:balu_sto/screens/mobile/splashScreen/bloc/splash_screen_bloc.dart';
import 'package:balu_sto/widgets/pages/koin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreenPage extends KoinPage<SplashScreenBloc> {
  static const PAGE_NAME = 'SplashScreenPage';

  @override
  void initBloc(SplashScreenBloc bloc) {
    bloc.add(SplashScreenEvent.INIT);
  }

  @override
  Widget buildPage(BuildContext context) => Scaffold(
        body: BlocListener<SplashScreenBloc, SplashScreenState>(
            listener: _handleEvents,
            child: Container(
              color: Colors.red,
            )),
      );

  void _handleEvents(BuildContext context, SplashScreenState state) {
    switch (state.runtimeType) {
      case SplashScreenStateNotLogged:
        Navigator.of(context).pushNamedAndRemoveUntil(
          LoginPage.PAGE_NAME,
          (Route<dynamic> route) => false,
        );
        break;
    }
  }
}
