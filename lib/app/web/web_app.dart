import 'package:balu_sto/app/web/app_module.dart';
import 'package:balu_sto/helpers/styles/theme.dart';
import 'package:balu_sto/screens/mobile/home/view/home_page.dart';
import 'package:balu_sto/screens/shared/sharedModule.dart';
import 'package:flutter/material.dart';
import 'package:koin/koin.dart';

class WebApp extends StatelessWidget {
  static void initKoin() {
    startKoin((app) {
      app.printLogger(level: Level.debug);
      app.modules([appModule, sharedModule]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: createTheme(context),
      initialRoute: '',
      routes: routes,
      onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => getGenerateRoutePage(settings),
      ),
    );
  }

  final routes = <String, WidgetBuilder>{};

  final Widget Function(RouteSettings) getGenerateRoutePage = (RouteSettings settings) {
    /*switch (settings.name) {
    case EmailConfirmationPage.ROUTE_NAME:
      return EmailConfirmationPage(settings.arguments! as EmailConfirmationPageArgs);
    default:
      throw Exception('Not screen specified to route ${settings.name}');
  }*/
    throw Exception('Not screen specified to route ${settings.name}');
  };
}
