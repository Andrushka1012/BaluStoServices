import 'package:balu_sto/features/firestore/models/user.dart';
import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/screens/shared/home/serviceDetails/view/service_details_page.dart';
import 'package:balu_sto/screens/shared/home/serviceModification/view/services_modification_page.dart';
import 'package:balu_sto/screens/shared/home/servicesList/view/services_list_page.dart';
import 'package:balu_sto/screens/shared/home/userServices/view/user_services_form.dart';
import 'package:balu_sto/widgets/balu_appbar.dart';
import 'package:balu_sto/widgets/containers/app_popup_menu_button.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  static const PAGE_NAME = 'UserProfilePage';

  static getPageName(String userId) => 'user/$userId/$PAGE_NAME';

  UserProfilePage(this._args);

  final UserProfilePageArg _args;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaluAppbar(
        title: _args.user?.name ?? 'Профиль',
        showBack: true,
        actions: [
          AppPopupMenuButton(
            items: [
              AppPopupMenuButtonItem(
                text: 'Прийнять оплату',
                onPressed: () => Navigator.of(context).pushNamed(
                  ServicesModificationPage.PAGE_NAME,
                  arguments: ServicesModificationPageArgs(
                    mode: ServicesModificationMode.CONFIRMATION,
                    userId: _args.userId,
                  ),
                ),
              ),
              AppPopupMenuButtonItem(
                text: 'Выдать зарплату',
                onPressed: () => Navigator.of(context).pushNamed(
                  ServicesModificationPage.PAGE_NAME,
                  arguments: ServicesModificationPageArgs(
                    mode: ServicesModificationMode.PAYMENT,
                    userId: _args.userId,
                  ),
                ),
              ),
            ],
            child: IconButton(
              icon: Icon(Icons.more_vert_outlined),
              onPressed: () {},
            ),
          )
        ],
      ),
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          UserServicesForm(
            userId: _args.userId,
            onServiceSelected: (service) => Navigator.of(context).pushNamed(
              ServiceDetailsPage.getPageName(_args.userId, service.id),
              arguments: ServiceDetailsPageArgs(
                service,
              ),
            ),
            onShowAll: () => Navigator.of(context).pushNamed(
              ServicesListPage.getPageName(_args.userId),
            ),
          ),
        ],
      ),
    );
  }
}

class UserProfilePageArg {
  UserProfilePageArg({
    required this.userId,
    this.user,
  });

  final String userId;
  AppUser? user;
}
