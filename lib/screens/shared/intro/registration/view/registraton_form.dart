import 'package:balu_sto/helpers/dialogs.dart';
import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:balu_sto/helpers/styles/text_styles.dart';
import 'package:balu_sto/screens/shared/intro/registration/bloc/registration_bloc.dart';
import 'package:balu_sto/widgets/containers/progress_container.dart';
import 'package:balu_sto/widgets/inputs/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  var _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegistrationBloc, RegistrationState>(
        listener: _handleEvents,
        buildWhen: (_, current) => current is! RegistrationStateError && current is! RegistrationStateRegistered,
        builder: (context, RegistrationState state) {
          return ProgressContainer(
            isProcessing: state is RegistrationStateProcessing,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextInput(
                      label: 'Имя',
                      hint: 'Введите Имя',
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onChanged: (value) => context.read<RegistrationBloc>().add(
                            RegistrationEventNameChanged(value),
                          ),
                    ),
                    SizedBox(
                      height: Dimens.spanSmall,
                    ),
                    TextInput(
                      label: 'Емейл',
                      hint: 'Введите Емейл',
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => context.read<RegistrationBloc>().add(
                            RegistrationEventEmailChanged(value),
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
                      onChanged: (value) => context.read<RegistrationBloc>().add(
                            RegistrationEventPasswordChanged(value),
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
                  ],
                ),
                SizedBox(
                  height: Dimens.spanSmall,
                ),
                SizedBox(
                  width: double.infinity,
                  height: Dimens.spanSmallerGiant,
                  child: ElevatedButton(
                    child: Text('Создать аккаунт', style: AppTextStyles.bodyText1),
                    style: ElevatedButton.styleFrom(primary: AppColors.primary),
                    onPressed: () => context.read<RegistrationBloc>().add(
                          RegistrationEventCreate(),
                        ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _handleEvents(BuildContext context, RegistrationState state) {
    if (state is RegistrationStateError) {
      showErrorDialog(context, state.error);
    }
    if (state is RegistrationStateRegistered) {
      showDialogMessage(
        context,
        title: 'Аккаунт создан',
        message: 'Теперь вы можете войти на свой аккаунт.',
        action: () => Navigator.of(context).pop(),
        barrierDismissible: false,
      );
    }
  }
}
