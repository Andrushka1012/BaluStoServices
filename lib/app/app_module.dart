import 'package:balu_sto/features/firestore/dao/assets_dao.dart';
import 'package:balu_sto/features/firestore/firestore_repository.dart';
import 'package:balu_sto/features/firestore/models/service.dart';
import 'package:balu_sto/helpers/pair.dart';
import 'package:balu_sto/helpers/preferences/preferences_provider.dart';
import 'package:balu_sto/infrastructure/auth/auth_handler.dart';
import 'package:balu_sto/infrastructure/auth/user_identity.dart';
import 'package:balu_sto/infrastructure/database/directory_util.dart';
import 'package:balu_sto/infrastructure/database/local_data_base.dart';
import 'package:balu_sto/screens/mobile/service/service/service_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:koin/koin.dart';

final appModule = Module()
  ..single((scope) => DirectoryUtil())
  ..single((scope) => LocalDatabase(scope.get<DirectoryUtil>()))
  ..single((scope) => AssetsDao(scope.get<LocalDatabase>()))
  ..factoryWithParam<ServiceBloc, Pair<Service?, bool>>(
    (scope, Pair<Service?, bool> args) => ServiceBloc(
      args,
      scope.get<FirestoreRepository>(),
    ),
  )
  ..single((scope) => UserIdentity())
  ..single((scope) => PreferencesProvider.instance)
  ..single((scope) => FirebaseAuth.instance)
  ..single((scope) => FirestoreRepository(scope, scope.get()))
  ..single((scope) => AuthHandler(
        scope.get(),
        scope.get(),
        scope.get(),
        scope.get(),
      ));
