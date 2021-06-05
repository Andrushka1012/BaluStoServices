part of 'registration_bloc.dart';

@immutable
abstract class RegistrationState {}

class RegistrationStateInput extends RegistrationState {
  RegistrationStateInput({
    this.name = '',
    this.email = '',
    this.password = '',
  });

  final String name;
  final String email;
  final String password;

  RegistrationStateInput copyWith({
    String? name,
    String? email,
    String? password,
  }) =>
      RegistrationStateInput(
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
      );
}

class RegistrationStateRegistered extends RegistrationState {}

class RegistrationStateProcessing extends RegistrationState {}

class RegistrationStateError extends RegistrationState {
  RegistrationStateError(this.error);

  final dynamic error;
}
