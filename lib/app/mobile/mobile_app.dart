import 'package:balu_sto/core_module.dart';
import 'package:balu_sto/helpers/styles/theme.dart';
import 'package:balu_sto/screens/mobile/home/view/home_page.dart';
import 'package:balu_sto/screens/mobile/login/view/login_page.dart';
import 'package:balu_sto/screens/mobile/splashScreen/view/splash_screen_page.dart';
import 'package:balu_sto/screens/shared/forgotPassword/view/forgot_password_page.dart';
import 'package:balu_sto/screens/shared/registration/view/registration_page.dart';
import 'package:balu_sto/screens/shared/sharedModule.dart';
import 'package:flutter/material.dart';
import 'package:koin/koin.dart';

import 'mobile_app_module.dart';

class MobileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: createTheme(context),
      initialRoute: SplashScreenMobilePage.PAGE_NAME,
      routes: routes,
      onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => getGenerateRoutePage(settings),
      ),
    );
  }

  static void initKoin() {
    startKoin((app) {
      app.printLogger(level: Level.debug);
      app.modules([
        coreModule,
        mobileAppModule,
        sharedModule
      ]);
    });
  }
}

final routes = <String, WidgetBuilder>{
  SplashScreenMobilePage.PAGE_NAME: (context) => SplashScreenMobilePage(),
  LoginMobilePage.PAGE_NAME: (context) => LoginMobilePage(),
  RegistrationPage.PAGE_NAME: (context) => RegistrationPage(),
  ForgotPasswordPage.PAGE_NAME: (context) => ForgotPasswordPage(),
  HomeMobilePage.PAGE_NAME: (context) => HomeMobilePage(),
};

final Widget Function(RouteSettings) getGenerateRoutePage = (RouteSettings settings) {
  /*switch (settings.name) {
    case EmailConfirmationPage.ROUTE_NAME:
      return EmailConfirmationPage(settings.arguments! as EmailConfirmationPageArgs);
    default:
      throw Exception('Not screen specified to route ${settings.name}');
  }*/
  throw Exception('Not screen specified to route ${settings.name}');
};
