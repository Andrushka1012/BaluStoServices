import 'package:koin/koin.dart';

import '../../infrastructure/database/directory_util.dart';
import '../../infrastructure/database/local_data_base.dart';

final mobileAppModule = Module()
  ..single((scope) => DirectoryUtil())
  ..single((scope) => LocalDatabase(scope.get<DirectoryUtil>()));
