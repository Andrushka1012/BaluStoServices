import 'package:balu_sto/helpers/dialogs.dart';
import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:balu_sto/screens/mobile/home/view/home_page.dart';
import 'package:balu_sto/screens/shared/registration/bloc/registration_bloc.dart';
import 'package:balu_sto/screens/shared/registration/view/registraton_form.dart';
import 'package:balu_sto/widgets/containers/web_constraints_container.dart';
import 'package:balu_sto/widgets/containers/web_limitation_container.dart';
import 'package:balu_sto/widgets/pages/koin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationPage extends KoinPage<RegistrationBloc> {
  static const PAGE_NAME = 'RegistrationPage';

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: WebLimitationContainer(
          child: SingleChildScrollView(
            child: Card(
              margin: const EdgeInsets.all(Dimens.spanSmall),
              child: Padding(
                padding: const EdgeInsets.all(Dimens.spanBig),
                child: RegistrationForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
