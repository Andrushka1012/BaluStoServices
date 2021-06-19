import 'package:balu_sto/helpers/dialogs.dart';
import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:balu_sto/helpers/styles/text_styles.dart';
import 'package:balu_sto/widgets/app_card.dart';
import 'package:balu_sto/widgets/inputs/text_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordForm extends StatelessWidget {
  final _emailTextController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Введите ваш адрес емейл и мы поможем Вам востановить аккаунт',
            style: AppTextStyles.bodyText1,
          ),
          SizedBox(
            height: Dimens.spanHuge,
          ),
          TextInput(
            controller: _emailTextController,
            label: 'Емейл',
            hint: 'Емейл адрес',
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(
            height: Dimens.spanSmall,
          ),
          SizedBox(
            width: double.infinity,
            height: Dimens.spanSmallerGiant,
            child: ElevatedButton(
              child: Text('Отправить ссылку сброса', style: AppTextStyles.bodyText1),
              style: ElevatedButton.styleFrom(primary: AppColors.primary),
              onPressed: () => _resetPassword(context),
            ),
          ),
        ],
      ),
    );
  }

  void _resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailTextController.text);
      showDialogMessage(context, title: 'Отправленно', message: 'Проверте Вашу почту.');
      Navigator.of(context).pop();
    } catch (e) {
      showErrorDialog(context, e);
    }
  }
}
