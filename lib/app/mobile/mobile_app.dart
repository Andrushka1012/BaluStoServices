import 'package:balu_sto/screens/mobile/formgotPassword/view/forgot_password_page.dart';
import 'package:balu_sto/screens/mobile/home/view/home_page.dart';
import 'package:balu_sto/screens/mobile/login/view/login_page.dart';
import 'package:balu_sto/screens/mobile/mobile_module.dart';
import 'package:balu_sto/screens/mobile/registration/view/registration_page.dart';
import 'package:balu_sto/screens/mobile/splashScreen/view/splash_screen_page.dart';
import 'package:balu_sto/screens/shared/sharedModule.dart';
import 'package:flutter/material.dart';
import 'package:koin/koin.dart';

import 'app_module.dart';

class MobileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: SplashScreenPage.PAGE_NAME,
      routes: routes,
      onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => getGenerateRoutePage(settings),
      ),
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
    );
  }

  static void initKoin() {
    startKoin((app) {
      app.printLogger(level: Level.debug);
      app.modules([
        appModule,
        mobileModule,
        sharedModule
      ]);
    });
  }
}

final routes = <String, WidgetBuilder>{
  SplashScreenPage.PAGE_NAME: (context) => SplashScreenPage(),
  LoginPage.PAGE_NAME: (context) => LoginPage(),
  RegistrationPage.PAGE_NAME: (context) => RegistrationPage(),
  ForgotPasswordPage.PAGE_NAME: (context) => ForgotPasswordPage(),
  HomePage.PAGE_NAME: (context) => HomePage(),
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
