import 'package:balu_sto/screens/shared/forgotPassword/view/forgot_password_form.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {

  static const PAGE_NAME = 'ForgotPasswordPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ForgotPasswordForm(),
    );
  }
}
