import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/infrastructure/auth/user_identity.dart';
import 'package:balu_sto/screens/shared/home/servicesList/view/services_list_form.dart';
import 'package:balu_sto/widgets/balu_appbar.dart';
import 'package:flutter/material.dart';
import 'package:koin_flutter/koin_flutter.dart';

class ServicesListPage extends StatelessWidget {
  static const PAGE_NAME = 'ServicesListPage';
  static getPageName(String userId) => 'user/$userId/ServicesListPage';

  ServicesListPage(this._args);

  final ServicesListPageArgs _args;
  late final UserIdentity _userIdentity = get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryDark,
      appBar: BaluAppbar(
        title: _args.userId == _userIdentity.requiredCurrentUser.userId ? 'Ваши услуги' : 'Услуги ${_args.userName ?? ''}',
        showBack: true,
      ),
      body: ServicesListForm(_args.userId),
    );
  }
}

class ServicesListPageArgs {
  String userId;
  String? userName;

  ServicesListPageArgs({
    required this.userId,
    this.userName,
  });
}
