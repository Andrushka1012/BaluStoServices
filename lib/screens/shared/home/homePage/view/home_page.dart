import 'package:balu_sto/features/firestore/models/service_status.dart';
import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/infrastructure/auth/user_identity.dart';
import 'package:balu_sto/screens/mobile/service/view/service_page.dart';
import 'package:balu_sto/screens/shared/home/serviceDetails/view/service_details_page.dart';
import 'package:balu_sto/screens/shared/home/servicesList/view/services_list_page.dart';
import 'package:balu_sto/screens/shared/home/transactionsList/view/transactions_list_form.dart';
import 'package:balu_sto/screens/shared/home/userServices/view/user_services_form.dart';
import 'package:balu_sto/screens/shared/widget/main_drawer.dart';
import 'package:balu_sto/widgets/balu_appbar.dart';
import 'package:flutter/material.dart';
import 'package:koin_flutter/koin_flutter.dart';

class HomePage extends StatelessWidget {
  static const PAGE_NAME = 'HomePage';

  late final UserIdentity _userIdentity = get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaluAppbar(
        title: 'Здравствуйте, ${_userIdentity.requiredCurrentUser.name}',
        defaultLeading: true,
      ),
      backgroundColor: AppColors.background,
      drawer: MainDrawer(),
      body: SafeArea(
        child: ListView(
          children: [
            UserServicesForm(
              userId: _userIdentity.requiredCurrentUser.userId,
              onServiceSelected: (service) => service.status == ServiceStatus.NOT_CONFIRMED
                  ? Navigator.of(context).pushNamed(
                      ServicePage.PAGE_NAME,
                      arguments: ServicePageArgs(
                        editMode: true,
                        service: service,
                      ),
                    )
                  : Navigator.of(context).pushNamed(
                      ServiceDetailsPage.getPageName(service.userId, service.id),
                      arguments: ServiceDetailsPageArgs(
                        service,
                      ),
                    ),
              onShowAll: () => Navigator.of(context).pushNamed(
                ServicesListPage.getPageName(_userIdentity.requiredCurrentUser.userId),
              ),
            ),
            TransactionsListForm(
              userId: _userIdentity.requiredCurrentUser.userId,
            )
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
}
