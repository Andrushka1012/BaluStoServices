import 'package:balu_sto/infrastructure/auth/auth_handler.dart';
import 'package:balu_sto/infrastructure/auth/user_identity.dart';
import 'package:balu_sto/screens/shared/home/userServices/view/user_services_form.dart';
import 'package:balu_sto/screens/shared/home/servicesList/view/services_list_page.dart';
import 'package:balu_sto/screens/web/login/view/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:koin_flutter/koin_flutter.dart';

class HomeWebPage extends StatelessWidget {
  static const PAGE_NAME = 'HomePage';

  late final AuthHandler _authHandler = get();
  late final UserIdentity _userIdentity = get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          UserServicesForm(
            userId: _userIdentity.requiredCurrentUser.userId,
            onServiceSelected: (service) {},
            onShowAll: () => Navigator.of(context).pushNamed(
              ServicesListPage.getPageName('wDkoVRuTfBNJa9QHET69MOu79y83'),
            ),
          ),
          ElevatedButton(
            child: Text("Выйти"),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await _authHandler.logout();
    Navigator.of(context).pushNamedAndRemoveUntil(
      LoginWebPage.PAGE_NAME,
      (Route<dynamic> route) => false,
    );
  }
}
