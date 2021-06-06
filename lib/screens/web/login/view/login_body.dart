import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:balu_sto/helpers/styles/text_styles.dart';
import 'package:balu_sto/screens/shared/intro/login/view/login_form.dart';
import 'package:balu_sto/screens/shared/intro/registration/view/registration_page.dart';

import 'package:balu_sto/widgets/containers/intro_container.dart';
import 'package:balu_sto/widgets/containers/web_constraints_container.dart';
import 'package:balu_sto/widgets/logos/app_logo.dart';
import 'package:balu_sto/widgets/logos/app_name_logo.dart';
import 'package:flutter/material.dart';

class LoginBody extends StatelessWidget {
  Widget _getIntroItem(BuildContext context) => Padding(
        padding: const EdgeInsets.all(Dimens.spanBig),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppNameLogo(),
            Container(
                padding: EdgeInsets.symmetric(vertical: Dimens.spanBig),
                width: Dimens.spanLarge,
                child: Divider(
                  height: 2,
                  color: AppColors.white,
                )),
            Text(
              'Мы поможем',
              style: AppTextStyles.bodyText1.copyWith(
                color: AppColors.white,
              ),
            ),
            Text(
              'Вести учет рабочего времени',
              style: AppTextStyles.headline3.copyWith(
                color: AppColors.white,
              ),
            ),
            Text(
              'Вы сможете в удобный способ остлеживать свою работу.\nВсегда иметь доступ к Вашей статистике через веб-сайт или мобильное приложение.',
              style: AppTextStyles.bodyText2.copyWith(
                color: AppColors.white,
              ),
            ),
            Spacer(),
            _getRegistrationRow(context),
            SizedBox(
              height: Dimens.spanSmall,
            )
          ],
        ),
      );

  Widget _getRegistrationRow(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Еще нет аккаунта?',
            style: AppTextStyles.bodyText2.copyWith(
              color: AppColors.white,
            ),
          ),
          SizedBox(
            height: Dimens.spanTiny,
          ),
          OutlinedButton(
            child: Text(
              'Зарегистрируйся',
              style: AppTextStyles.bodyText1.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => Navigator.of(context).pushNamed(RegistrationPage.PAGE_NAME),
            style: OutlinedButton.styleFrom(
              primary: AppColors.secondaryDark,
              side: BorderSide(color: AppColors.white, width: 1),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: WebConstraintsContainer(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Dimens.spanLarge,
                horizontal: Dimens.spanBig,
              ),
              child: Card(
                elevation: Dimens.spanSmall,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.spanHuge),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: IntroContainer(
                        child: _getIntroItem(context),
                        fullScreen: false,
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: FractionallySizedBox(
                        widthFactor: 0.75,
                        child: LoginForm(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: Dimens.spanBig,
              right: Dimens.spanSmall,
              child: SizedBox(
                width: Dimens.spanBiggerGiant,
                height: Dimens.spanBiggerGiant,
                child: AppLogo(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
