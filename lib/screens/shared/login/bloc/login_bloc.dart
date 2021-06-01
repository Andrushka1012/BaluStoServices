import 'dart:async';

import 'package:balu_sto/helpers/preferences/preferences_provider.dart';
import 'package:balu_sto/infrastructure/auth/auth_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._authHandler, PreferencesProvider preferencesProvide)
      : super(LoginStateInput(
          email: preferencesProvide.prefillEmail.value,
        ));

  final AuthHandler _authHandler;

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    print(event);
    if (state is! LoginStateInput) return;
    final LoginStateInput inputState = state as LoginStateInput;

    switch (event.runtimeType) {
      case LoginEventEmailChanged:
        yield inputState.copyWith(email: (event as LoginEventEmailChanged).value);
        break;
      case LoginEventPasswordChanged:
        yield inputState.copyWith(password: (event as LoginEventPasswordChanged).value);
        break;
      case LoginEventAttempt:
        yield* _tryToLogin(inputState);
        break;
    }
  }

  Stream<LoginState> _tryToLogin(LoginStateInput inputState) async* {
    yield LoginStateProcessing();
    final loginResult = await _authHandler.signInWithEmailAndPassword(
      email: inputState.email,
      password: inputState.password,
    );

    if (loginResult.isSuccessful) {
      yield LoginStateLogged();
    } else {
      yield LoginStateError(loginResult.requiredError);
      yield inputState;
    }
  }
}
