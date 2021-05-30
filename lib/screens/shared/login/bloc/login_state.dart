part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginStateInput extends LoginState {
  LoginStateInput({
    this.email = '',
    this.password = '',
  });

  final String email;
  final String password;

  LoginStateInput copyWith({
    String? name,
    String? email,
    String? password,
  }) =>
      LoginStateInput(
        email: email ?? this.email,
        password: password ?? this.password,
      );
}

class LoginStateLogged extends LoginState {}
