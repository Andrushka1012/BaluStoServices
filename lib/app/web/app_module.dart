import 'package:balu_sto/infrastructure/auth/auth_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:koin/koin.dart';

import '../../helpers/preferences/preferences_provider.dart';

final appModule = Module()
  ..single((scope) => PreferencesProvider.instance)
  ..single((scope) => FirebaseAuth.instance)
  ..single((scope) => AuthHandler(scope.get(), scope.get()));
