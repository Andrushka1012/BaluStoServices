import 'package:balu_sto/helpers/preferences/preferences_provider.dart';
import 'package:balu_sto/screens/mobile/formgotPassword/view/forgot_password_page.dart';
import 'package:balu_sto/screens/shared/login/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin_flutter/koin_flutter.dart';

class LoginForm extends StatelessWidget {
  late final PreferencesProvider _preferencesProvider = get();
  late final _emailTextController = TextEditingController(text: _preferencesProvider.prefillEmail.value);

  @override
  Widget build(BuildContext context) {
    var passwordVisible = false;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _emailTextController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Емаил', hintText: 'example@gmail.ua'),
                  enableSuggestions: false,
                  autocorrect: false,
                  onChanged: (value) => context.read<LoginBloc>().add(
                        LoginEventEmailChanged(value),
                      ),
                ),
              ),
              StatefulBuilder(builder: (context, setState) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: !passwordVisible,
                    decoration: InputDecoration(
                        labelText: 'Пароль',
                        suffixIcon: IconButton(
                            icon: Icon(
                              passwordVisible ? Icons.visibility : Icons.visibility_off,
                              size: 24,
                            ),
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            })),
                    enableSuggestions: false,
                    autocorrect: false,
                    onChanged: (value) => context.read<LoginBloc>().add(
                          LoginEventPasswordChanged(value),
                        ),
                  ),
                );
              }),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            child: Text('Войти'),
            onPressed: () => context.read<LoginBloc>().add(
                  LoginEventAttempt(),
                ),
          ),
        ),
        ElevatedButton(
          child: Text('Забыл пароль?'),
          onPressed: () => Navigator.of(context).pushNamed(ForgotPasswordPage.PAGE_NAME),
        ),
      ],
    );
  }
}
