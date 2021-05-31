import 'package:balu_sto/helpers/preferences/preferences_provider.dart';
import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:balu_sto/helpers/styles/text_styles.dart';
import 'package:balu_sto/screens/shared/login/bloc/login_bloc.dart';
import 'package:balu_sto/widgets/containers/progress_container.dart';
import 'package:balu_sto/widgets/input_decoration.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (_, current) => current is LoginStateProcessing || current is LoginStateInput,
        builder: (context, LoginState state) {
          return ProgressContainer(
            isProcessing: state is LoginStateProcessing,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Войти',
                      style: AppTextStyles.headline1.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryDark,
                      )),
                  SizedBox(
                    height: Dimens.spanBig,
                  ),
                  Text(
                    'Емейл адрес',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryDark,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimens.spanTiny,
                      horizontal: Dimens.spanMicro,
                    ),
                    child: TextField(
                      controller: _emailTextController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: getDecoration().copyWith(
                        hintText: 'Введите Емейл',
                      ),
                      enableSuggestions: false,
                      autocorrect: false,
                      onChanged: (value) => context.read<LoginBloc>().add(
                            LoginEventEmailChanged(value),
                          ),
                    ),
                  ),
                  SizedBox(
                    height: Dimens.spanSmall,
                  ),
                  Text(
                    'Пароль',
                    style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.secondaryDark),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimens.spanTiny,
                      horizontal: Dimens.spanMicro,
                    ),
                    child: TextField(
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: !_passwordVisible,
                      decoration: getDecoration().copyWith(
                        hintText: 'Введите Пароль',
                      ),
                      enableSuggestions: false,
                      autocorrect: false,
                      onChanged: (value) => context.read<LoginBloc>().add(
                            LoginEventPasswordChanged(value),
                          ),
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
                      style: ElevatedButton.styleFrom(primary: AppColors.primaryDark),
                      onPressed: () => context.read<LoginBloc>().add(
                            LoginEventAttempt(),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
