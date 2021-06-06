import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/helpers/styles/text_styles.dart';
import 'package:balu_sto/infrastructure/auth/auth_handler.dart';
import 'package:balu_sto/infrastructure/auth/user_identity.dart';
import 'package:balu_sto/screens/mobile/login/view/login_page.dart';
import 'package:balu_sto/screens/shared/employeesList/view/employees_list_page.dart';
import 'package:balu_sto/screens/shared/serviceModification/view/services_modification_page.dart';
import 'package:balu_sto/screens/web/login/view/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:koin_flutter/koin_flutter.dart';

class MainDrawer extends StatelessWidget {
  late final AuthHandler _authHandler = get();
  late final UserIdentity _userIdentity = get();

  @override
  Widget build(BuildContext context) => Drawer(
        child: Container(
          color: AppColors.secondary,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/images/into_background.png'),
                  fit: BoxFit.cover,
                )),
                child: Container(),
              ),
              if (_userIdentity.isAdmin) ...[
                ListTile(
                  title: Text(
                    'Список работников',
                    style: AppTextStyles.bodyText1w500,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(EmployeesListPage.PAGE_NAME);
                  },
                ),
                Divider(
                  color: AppColors.white,
                ),
              ],
              if (_userIdentity.isAdmin) ...[
                ListTile(
                  title: Text(
                    'Прийнять оплату',
                    style: AppTextStyles.bodyText1w500,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(
                      ServicesModificationPage.PAGE_NAME,
                      arguments: ServicesModificationPageArgs(
                        mode: ServicesModificationMode.CONFIRMATION,
                      ),
                    );
                  },
                ),
                Divider(
                  color: AppColors.white,
                ),
              ],
              if (_userIdentity.isAdmin) ...[
                ListTile(
                  title: Text(
                    'Выдать зарплату',
                    style: AppTextStyles.bodyText1w500,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(
                      ServicesModificationPage.PAGE_NAME,
                      arguments: ServicesModificationPageArgs(
                        mode: ServicesModificationMode.PAYMENT,
                      ),
                    );
                  },
                ),
                Divider(
                  color: AppColors.white,
                ),
              ],
              ListTile(
                title: Text(
                  'Выйти',
                  style: AppTextStyles.bodyText1w500,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _logout(context);
                },
              ),
              Divider(
                color: AppColors.white,
              ),
            ],
          ),
        ),
      );

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await _authHandler.logout();

    final loginPage = kIsWeb ? LoginWebPage.PAGE_NAME : LoginMobilePage.PAGE_NAME;

    Navigator.of(context).pushNamedAndRemoveUntil(
      loginPage,
      (Route<dynamic> route) => false,
    );
  }
}
