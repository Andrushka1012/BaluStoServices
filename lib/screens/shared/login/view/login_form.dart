import 'package:balu_sto/helpers/preferences/preferences_provider.dart';
import 'package:balu_sto/screens/shared/login/bloc/login_bloc.dart';
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _emailTextController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: getDecoration().copyWith(
              labelText: 'Емаил',
              hintText: 'example@gmail.ua',
            ),
            enableSuggestions: false,
            autocorrect: false,
            onChanged: (value) => context.read<LoginBloc>().add(
                  LoginEventEmailChanged(value),
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.visiblePassword,
            obscureText: !_passwordVisible,
            decoration: getDecoration().copyWith(
              labelText: 'Пароль',
            ),
            enableSuggestions: false,
            autocorrect: false,
            onChanged: (value) => context.read<LoginBloc>().add(
                  LoginEventPasswordChanged(value),
                ),
          ),
        ),
        Row(
          children: [
            Checkbox(
                value: _passwordVisible,
                onChanged: (value) {
                  setState(() {
                    _passwordVisible = value!;
                  });
                }),
            Text('Показать пароль')
          ],
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
      ],
    );
  }
}
