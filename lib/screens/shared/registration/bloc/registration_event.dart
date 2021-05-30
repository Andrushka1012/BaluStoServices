part of 'registration_bloc.dart';

@immutable
abstract class RegistrationEvent {}

class RegistrationEventNameChanged extends RegistrationEvent {
  RegistrationEventNameChanged(this.value);

  final String value;
}

class RegistrationEventEmailChanged extends RegistrationEvent {
  RegistrationEventEmailChanged(this.value);

  final String value;
}

class RegistrationEventPasswordChanged extends RegistrationEvent {
  RegistrationEventPasswordChanged(this.value);

  final String value;
}

class RegistrationEventCreate extends RegistrationEvent {
}
