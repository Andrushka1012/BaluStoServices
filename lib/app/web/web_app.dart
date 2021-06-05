import 'package:balu_sto/app/share_pages.dart';
import 'package:balu_sto/core_module.dart';
import 'package:balu_sto/helpers/styles/theme.dart';
import 'package:balu_sto/screens/shared/forgotPassword/view/forgot_password_page.dart';
import 'package:balu_sto/screens/shared/home/servicesList/view/services_list_page.dart';
import 'package:balu_sto/screens/shared/registration/view/registration_page.dart';
import 'package:balu_sto/screens/shared/sharedModule.dart';
import 'package:balu_sto/screens/web/home/view/home_page.dart';
import 'package:balu_sto/screens/web/login/view/login_page.dart';
import 'package:balu_sto/screens/web/splashScreen/view/splash_screen_page.dart';
import 'package:balu_sto/screens/web/web_module.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:koin/koin.dart';
import 'package:koin_flutter/koin_flutter.dart';

class WebApp extends StatelessWidget {
  late final FirebaseAuth _firebaseAuth = get();

  static void initKoin() {
    startKoin((app) {
      app.printLogger(level: Level.debug);
      app.modules([
        coreModule,
        webModule,
        sharedModule,
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Балу СТО Services',
      theme: createTheme(context),
      initialRoute: SplashScreenWebPage.PAGE_NAME,
      onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => getGenerateRoutePage(settings),
      ),
    );
  }

  late final Widget Function(RouteSettings) getGenerateRoutePage = (RouteSettings settings) {
    switch (settings.name) {
      case SplashScreenWebPage.PAGE_NAME:
        return SplashScreenWebPage();
      case LoginWebPage.PAGE_NAME:
        return LoginWebPage();
      case RegistrationPage.PAGE_NAME:
        return RegistrationPage();
      case ForgotPasswordPage.PAGE_NAME:
        return ForgotPasswordPage();
      case HomeWebPage.PAGE_NAME:
        return HomeWebPage();
      default:
        return getGenerateSharedRoutePage(settings);
    }
  };
}
