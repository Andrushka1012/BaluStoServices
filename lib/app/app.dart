import 'package:balu_sto/app/share_pages.dart';
import 'package:balu_sto/helpers/styles/theme.dart';
import 'package:balu_sto/screens/mobile/login/view/login_page.dart';
import 'package:balu_sto/screens/mobile/service/view/service_page.dart';
import 'package:balu_sto/screens/mobile/splashScreen/view/splash_screen_page.dart';
import 'package:balu_sto/screens/shared/home/homePage/view/home_page.dart';
import 'package:balu_sto/screens/shared/intro/forgotPassword/view/forgot_password_page.dart';
import 'package:balu_sto/screens/shared/intro/registration/view/registration_page.dart';
import 'package:balu_sto/screens/shared/sharedModule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:koin/koin.dart';

import 'app_module.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: createTheme(context),
      initialRoute: SplashScreenMobilePage.PAGE_NAME,
      routes: routes,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('ru'),
      ],
      onGenerateRoute: (RouteSettings settings) => PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return getGenerateRoutePage(settings);
        },
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  static void initKoin() {
    startKoin((app) {
      app.printLogger(level: Level.debug);
      app.modules([appModule, sharedModule]);
    });
  }
}

final routes = <String, WidgetBuilder>{
  SplashScreenMobilePage.PAGE_NAME: (context) => SplashScreenMobilePage(),
  LoginMobilePage.PAGE_NAME: (context) => LoginMobilePage(),
  RegistrationPage.PAGE_NAME: (context) => RegistrationPage(),
  ForgotPasswordPage.PAGE_NAME: (context) => ForgotPasswordPage(),
  HomePage.PAGE_NAME: (context) => HomePage(),
};

final Widget Function(RouteSettings) getGenerateRoutePage = (RouteSettings settings) {
  switch (settings.name) {
    case ServicePage.PAGE_NAME:
      return ServicePage(settings.arguments! as ServicePageArgs);
    default:
      return getGenerateSharedRoutePage(settings);
  }
};
