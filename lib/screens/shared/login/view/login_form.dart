import 'package:balu_sto/helpers/dialogs.dart';
import 'package:balu_sto/helpers/preferences/preferences_provider.dart';
import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:balu_sto/helpers/styles/text_styles.dart';
import 'package:balu_sto/screens/shared/forgotPassword/view/forgot_password_page.dart';
import 'package:balu_sto/screens/shared/login/bloc/login_bloc.dart';
import 'package:balu_sto/widgets/containers/progress_container.dart';
import 'package:balu_sto/widgets/inputs/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin_flutter/koin_flutter.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late final PreferencesProvider _preferencesProvider = get();

  late final _emailTextController = TextEditingController(text: _preferencesProvider.prefillEmail.value);

  var _passwordVisible = false;

  Widget _getResetPasswordRow(BuildContext context) => Padding(
        padding: const EdgeInsets.only(
          top: Dimens.spanBig,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Забыл пароль?',
              style: AppTextStyles.bodyText2,
            ),
            SizedBox(
              width: Dimens.spanSmall,
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(ForgotPasswordPage.PAGE_NAME),
              child: Text(
                'Востановить',
                style: AppTextStyles.bodyText1.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
        listener: _handleEvents,
        buildWhen: (_, current) => current is LoginStateProcessing || current is LoginStateInput,
        builder: (context, LoginState state) {
          return ProgressContainer(
            isProcessing: state is LoginStateProcessing,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Войти',
                    style: AppTextStyles.headline1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: Dimens.spanBig,
                  ),
                  TextInput(
                    controller: _emailTextController,
                    label: 'Емейл',
                    hint: 'Емейл адрес',
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => context.read<LoginBloc>().add(
                          LoginEventEmailChanged(value),
                        ),
                  ),
                  SizedBox(
                    height: Dimens.spanSmall,
                  ),
                  TextInput(
                    label: 'Пароль',
                    hint: 'Введите Пароль',
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: !_passwordVisible,
                    onChanged: (value) => context.read<LoginBloc>().add(
                          LoginEventPasswordChanged(value),
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimens.spanSmall),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: Dimens.spanHuge,
                          height: Dimens.spanHuge,
                          child: Checkbox(

                              value: _passwordVisible,
                              onChanged: (value) {
                                setState(() {
                                  _passwordVisible = value!;
                                });
                              }),
                        ),
                        SizedBox(
                          width: Dimens.spanTiny,
                        ),
                        Text(
                          'Показать пароль',
                          style: AppTextStyles.bodyText2,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dimens.spanSmall,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: Dimens.spanSmallerGiant,
                    child: ElevatedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Войти', style: AppTextStyles.bodyText1),
                          SizedBox(
                            width: Dimens.spanTiny,
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: Dimens.spanMedium,
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(primary: AppColors.primary),
                      onPressed: () => context.read<LoginBloc>().add(
                            LoginEventAttempt(),
                          ),
                    ),
                  ),
                  _getResetPasswordRow(context),
                ],
              ),
            ),
          );
        });
  }

  void _handleEvents(BuildContext context, LoginState state) {
    if (state is LoginStateError) {
      showErrorDialog(context, state.error);
    }
  }
}
