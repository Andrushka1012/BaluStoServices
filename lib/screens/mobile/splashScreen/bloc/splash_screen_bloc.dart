import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'splash_screen_event.dart';

part 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  SplashScreenBloc() : super(InitialSplashScreenState());

  @override
  Stream<SplashScreenState> mapEventToState(SplashScreenEvent event) async* {
    if (event == SplashScreenEvent.INIT) {
      yield* _initApp();
    }
  }

  Stream<SplashScreenState> _initApp() async* {
    await Future.delayed(Duration(seconds: 2));
    yield SplashScreenStateNotLogged();
  }
}
