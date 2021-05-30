import 'package:balu_sto/screens/shared/registration/bloc/registration_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationForm extends StatelessWidget {
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
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Имя',
                  ),
                  enableSuggestions: false,
                  autocorrect: false,
                  onChanged: (value) => context.read<RegistrationBloc>().add(
                        RegistrationEventNameChanged(value),
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Емаил',
                    hintText: 'example@gmail.ua',
                  ),
                  enableSuggestions: false,
                  autocorrect: false,
                  onChanged: (value) => context.read<RegistrationBloc>().add(
                        RegistrationEventEmailChanged(value),
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
                    onChanged: (value) => context.read<RegistrationBloc>().add(
                          RegistrationEventPasswordChanged(value),
                        ),
                  ),
                );
              }),
            ],
          ),
        ),
        ElevatedButton(
          child: Text('Создать аккаунт'),
          onPressed: () => context.read<RegistrationBloc>().add(
                RegistrationEventCreate(),
              ),
        )
      ],
    );
  }
}
