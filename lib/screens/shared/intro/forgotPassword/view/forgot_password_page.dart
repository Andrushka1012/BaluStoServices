import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/widgets/containers/web_limitation_container.dart';
import 'package:flutter/material.dart';

import 'forgot_password_form.dart';

class ForgotPasswordPage extends StatelessWidget {
  static const PAGE_NAME = 'ForgotPasswordPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: WebLimitationContainer(
        child: ForgotPasswordForm(),
      ),
    );
  }
}
