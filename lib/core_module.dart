import 'package:balu_sto/infrastructure/auth/auth_handler.dart';
import 'package:balu_sto/infrastructure/auth/user_identity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:koin/koin.dart';

import 'helpers/preferences/preferences_provider.dart';

final coreModule = Module()
  ..single((scope) => UserIdentity())
  ..single((scope) => PreferencesProvider.instance)
  ..single((scope) => FirebaseAuth.instance)
  ..single((scope) => AuthHandler(scope.get(), scope.get(), scope.get()));
