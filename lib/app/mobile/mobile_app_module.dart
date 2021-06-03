import 'package:balu_sto/features/firestore/dao/current_user_dao.dart';
import 'package:balu_sto/features/firestore/dao/services_dao.dart';
import 'package:balu_sto/features/firestore/firestore_repository.dart';
import 'package:balu_sto/features/firestore/models/service.dart';
import 'package:balu_sto/helpers/pair.dart';
import 'package:balu_sto/screens/mobile/service/service/service_bloc.dart';
import 'package:koin/koin.dart';

import '../../infrastructure/database/directory_util.dart';
import '../../infrastructure/database/local_data_base.dart';

final mobileAppModule = Module()
  ..single((scope) => DirectoryUtil())
  ..single((scope) => LocalDatabase(scope.get<DirectoryUtil>()))
  ..single((scope) => CurrentUserDao(scope.get<LocalDatabase>()))
  ..single((scope) => ServicesDao(scope.get<LocalDatabase>()))
  ..factoryWithParam<ServiceBloc, Pair<Service?, bool>>(
        (scope, Pair<Service?, bool> args) => ServiceBloc(args, scope.get<FirestoreRepository>()),
  );
