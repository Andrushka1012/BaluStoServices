import 'package:balu_sto/screens/mobile/splashScreen/bloc/splash_screen_bloc.dart';
import 'package:koin/koin.dart';

final mobileModule = Module()..factory((scope) => SplashScreenBloc());
