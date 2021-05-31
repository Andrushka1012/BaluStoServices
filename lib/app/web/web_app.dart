import 'package:balu_sto/app/web/app_module.dart';
import 'package:balu_sto/helpers/styles/theme.dart';
import 'package:balu_sto/screens/mobile/registration/view/registration_page.dart';
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
        appModule,
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
      case RegistrationMobilePage.PAGE_NAME:
        return RegistrationMobilePage();
      case HomeWebPage.PAGE_NAME:
        return HomeWebPage();
      default:
        throw Exception('Not screen specified to route ${settings.name} in communities navigation');
    }
  };
}
