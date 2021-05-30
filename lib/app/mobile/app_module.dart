import 'package:koin/koin.dart';

import '../../helpers/preferences/preferences_provider.dart';
import '../../infrastructure/database/directory_util.dart';
import '../../infrastructure/database/local_data_base.dart';

final appModule = Module()
  ..single((scope) => PreferencesProvider())
  ..single((scope) => DirectoryUtil())
  ..single((scope) => LocalDatabase(scope.get<DirectoryUtil>()));