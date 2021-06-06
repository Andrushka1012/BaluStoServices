import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:balu_sto/screens/mobile/login/view/login_page.dart';
import 'package:balu_sto/screens/shared/home/homePage/view/home_page.dart';
import 'package:balu_sto/screens/shared/intro/splashScreen/bloc/splash_screen_bloc.dart';
import 'package:balu_sto/widgets/logos/app_logo.dart';
import 'package:balu_sto/widgets/pages/koin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreenMobilePage extends KoinPage<SplashScreenBloc> {
  static const PAGE_NAME = '/';

  @override
  void initBloc(SplashScreenBloc bloc) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
    bloc.add(SplashScreenEvent.INIT);
  }

  @override
  Widget buildPage(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: BlocListener<SplashScreenBloc, SplashScreenState>(
            listener: _handleEvents,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(Dimens.spanGiant),
                child: AppLogo(),
              ),
            )),
      );

  void _handleEvents(BuildContext context, SplashScreenState state) {
    switch (state.runtimeType) {
      case SplashScreenStateNotLogged:
        Navigator.of(context).pushNamedAndRemoveUntil(
          LoginMobilePage.PAGE_NAME,
          (Route<dynamic> route) => false,
        );
        break;
      case SplashScreenStateLogged:
        Navigator.of(context).pushNamedAndRemoveUntil(
          HomePage.PAGE_NAME,
          (Route<dynamic> route) => false,
        );
        break;
    }
  }
}
