import 'dart:async';

import 'package:balu_sto/helpers/preferences/preferences_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'splash_screen_event.dart';

part 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  SplashScreenBloc(this._firebaseAuth, this._preferencesProvider) : super(InitialSplashScreenState());

  final FirebaseAuth _firebaseAuth;
  final PreferencesProvider _preferencesProvider;

  @override
  Stream<SplashScreenState> mapEventToState(SplashScreenEvent event) async* {
    if (event == SplashScreenEvent.INIT) {
      yield* _initApp();
    }
  }

  Stream<SplashScreenState> _initApp() async* {
    await initAppServices();
    await Future.delayed(Duration(seconds: 2));
    if (_firebaseAuth.currentUser != null) {
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
