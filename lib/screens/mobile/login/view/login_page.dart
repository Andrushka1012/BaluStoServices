import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:balu_sto/helpers/styles/text_styles.dart';
import 'package:balu_sto/screens/shared/home/homePage/view/home_page.dart';
import 'package:balu_sto/screens/shared/intro/login/bloc/login_bloc.dart';
import 'package:balu_sto/screens/shared/intro/login/view/login_form.dart';
import 'package:balu_sto/screens/shared/intro/registration/view/registration_page.dart';
import 'package:balu_sto/screens/web/login/view/login_page.dart';
import 'package:balu_sto/widgets/logos/app_logo.dart';
import 'package:balu_sto/widgets/pages/koin_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginMobilePage extends KoinPage<LoginBloc> {
  static const PAGE_NAME = 'LoginPage';

  @override
  Widget buildPage(BuildContext context) {
    return kIsWeb && MediaQuery.of(context).size.width >= 600? LoginWebPage() : Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<LoginBloc, LoginState>(
        listener: _listenEvents,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(Dimens.spanBig),
                  child: SizedBox(
                    width: Dimens.spanBiggerGiant,
                    height: Dimens.spanBiggerGiant,
                    child: AppLogo(),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(Dimens.spanSmall),
                  child: Padding(
                    padding: const EdgeInsets.all(Dimens.spanBig),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(child: LoginForm()),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: Dimens.spanBig),
                          child: Text(
                            '??????',
                            style: AppTextStyles.bodyText1,
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: Dimens.spanSmallerGiant,
                          child: OutlinedButton(
                            child: Text('?????????????? ??????????????', style: AppTextStyles.bodyText1),
                            onPressed: () => Navigator.of(context).pushNamed(RegistrationPage.PAGE_NAME),
                            style: OutlinedButton.styleFrom(
                              primary: AppColors.secondaryDark,
                              side: BorderSide(color: AppColors.primary, width: 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _listenEvents(BuildContext context, LoginState state) {
    if (state is LoginStateLogged) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        HomePage.PAGE_NAME,
        (Route<dynamic> route) => false,
      );
    }
  }
}
