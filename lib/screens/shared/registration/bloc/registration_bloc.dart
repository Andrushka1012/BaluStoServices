import 'dart:async';

import 'package:balu_sto/infrastructure/auth/auth_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'registration_event.dart';

part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc(this._firebaseAuth, this._authHandler) : super(RegistrationStateInput());

  final FirebaseAuth _firebaseAuth;
  final AuthHandler _authHandler;

  @override
  Stream<RegistrationState> mapEventToState(RegistrationEvent event) async* {
    if (state is! RegistrationStateInput) return;
    final RegistrationStateInput inputState = state as RegistrationStateInput;

    switch (event.runtimeType) {
      case RegistrationEventNameChanged:
        yield inputState.copyWith(name: (event as RegistrationEventNameChanged).value);
        break;
      case RegistrationEventEmailChanged:
        yield inputState.copyWith(email: (event as RegistrationEventEmailChanged).value);
        break;
      case RegistrationEventPasswordChanged:
        yield inputState.copyWith(password: (event as RegistrationEventPasswordChanged).value);
        break;
      case RegistrationEventCreate:
        yield* _registerAccount(inputState);
        break;
    }
  }

  Stream<RegistrationState> _registerAccount(RegistrationStateInput inputState) async* {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: inputState.email,
        password: inputState.password,
      );

      final loginResult = await _authHandler.signInWithEmailAndPassword(
        email: inputState.email,
        password: inputState.password,
      );

      if (loginResult.isSuccessful) {
        yield RegistrationStateLogged();
      } else {
        yield RegistrationStateError(loginResult.requiredError);
        yield inputState.copyWith();
      }
    } catch (e) {
      yield RegistrationStateError(e);
      yield inputState.copyWith();
    }
  }
}
