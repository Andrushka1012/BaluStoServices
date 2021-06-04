part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginStateInput extends LoginState {
  LoginStateInput({
    this.email = '',
    this.password = '!23Qwe',
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

class LoginStateProcessing extends LoginState {}

class LoginStateLogged extends LoginState {}

class LoginStateError extends LoginState {

  LoginStateError(this.error);
  final dynamic error;
}
