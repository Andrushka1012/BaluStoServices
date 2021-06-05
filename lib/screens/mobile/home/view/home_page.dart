import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/infrastructure/auth/auth_handler.dart';
import 'package:balu_sto/infrastructure/auth/user_identity.dart';
import 'package:balu_sto/screens/mobile/login/view/login_page.dart';
import 'package:balu_sto/screens/mobile/service/view/service_page.dart';
import 'package:balu_sto/screens/shared/home/recentServces/view/recent_services_form.dart';
import 'package:balu_sto/screens/shared/home/servicesList/view/services_list_page.dart';
import 'package:balu_sto/widgets/balu_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:koin_flutter/koin_flutter.dart';

class HomeMobilePage extends StatelessWidget {
  static const PAGE_NAME = 'HomePage';

  late final AuthHandler _authHandler = get();
  late final UserIdentity _userIdentity = get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaluAppbar(
        title: 'Здравствуйте, ${_userIdentity.requiredCurrentUser.name}',
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            RecentServicesForm(
              onServiceSelected: (service) => Navigator.of(context).pushNamed(
                ServicePage.PAGE_NAME,
                arguments: ServicePageArgs(
                  editMode: true,
                  service: service,
                ),
              ),
              onShowAll: () => Navigator.of(context).pushNamed(
                ServicesListPage.getPageName(_userIdentity.requiredCurrentUser.userId),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(ServicePage.PAGE_NAME,
            arguments: ServicePageArgs(
              editMode: false,
            )),
        backgroundColor: AppColors.secondary,
        child: Icon(
          Icons.add,
          color: AppColors.primary,
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await _authHandler.logout();
    Navigator.of(context).pushNamedAndRemoveUntil(
      LoginMobilePage.PAGE_NAME,
      (Route<dynamic> route) => false,
    );
  }
}
