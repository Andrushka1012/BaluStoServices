import 'package:balu_sto/infrastructure/auth/auth_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:koin/koin.dart';

import '../../helpers/preferences/preferences_provider.dart';
import '../../infrastructure/database/directory_util.dart';
import '../../infrastructure/database/local_data_base.dart';

final appModule = Module()
  ..single((scope) => PreferencesProvider.instance)
  ..single((scope) => DirectoryUtil())
  ..single((scope) => LocalDatabase(scope.get<DirectoryUtil>()))
  ..single((scope) => FirebaseAuth.instance)
  ..single((scope) => AuthHandler(scope.get(), scope.get()));