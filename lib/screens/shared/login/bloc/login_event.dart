part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginEventEmailChanged extends LoginEvent {
  LoginEventEmailChanged(this.value);

  final String value;
}

class LoginEventPasswordChanged extends LoginEvent {
  LoginEventPasswordChanged(this.value);

  final String value;
}

class LoginEventAttempt extends LoginEvent {}
