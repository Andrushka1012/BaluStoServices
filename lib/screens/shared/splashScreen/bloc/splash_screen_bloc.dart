import 'dart:async';

import 'package:balu_sto/helpers/preferences/preferences_provider.dart';
import 'package:balu_sto/infrastructure/auth/auth_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'splash_screen_event.dart';

part 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  SplashScreenBloc(
    this._firebaseAuth,
    this._preferencesProvider,
    this._authHandler,
  ) : super(InitialSplashScreenState());

  final FirebaseAuth _firebaseAuth;
  final PreferencesProvider _preferencesProvider;
  final AuthHandler _authHandler;

  @override
  Stream<SplashScreenState> mapEventToState(SplashScreenEvent event) async* {
    if (event == SplashScreenEvent.INIT) {
      yield* _initApp();
    }
  }

  Stream<SplashScreenState> _initApp() async* {
    await initAppServices();

    await Future.delayed(Duration(milliseconds: 750));

    if (_firebaseAuth.currentUser != null) {
      await _authHandler.initSession();
      yield SplashScreenStateLogged();
    } else {
      yield SplashScreenStateNotLogged();
    }
  }

  Future<void> initAppServices() async {
    if (!kIsWeb) {
      await _preferencesProvider.initialize();
    }
  }
}
