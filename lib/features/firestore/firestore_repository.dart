import 'dart:async';

import 'package:balu_sto/features/firestore/dao/services_dao.dart';
import 'package:balu_sto/features/firestore/models/service.dart';
import 'package:balu_sto/features/firestore/models/user.dart';
import 'package:balu_sto/helpers/fetch_helpers.dart';
import 'package:balu_sto/infrastructure/auth/user_identity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:koin/internals.dart';

class FirestoreRepository {
  FirestoreRepository(this._scope, this._userIdentity);

  final Scope _scope;
  final _firebaseAuth = FirebaseAuth.instance;
  final UserIdentity _userIdentity;
  late final ServicesDao _servicesDao = _scope.get();

  Stream<List<Service>>? get servicesStream => !kIsWeb ? _servicesDao.getAllStreamed() : null;

  CollectionReference<AppUser> get _usersCollection =>
      FirebaseFirestore.instance.collection(AppUser.COLLECTION_NAME).withConverter<AppUser>(
            fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, _) => AppUser.fromJson(snapshot.data()),
            toFirestore: (AppUser user, _) => user.toJson(),
          );

  CollectionReference<Service> get _servicesCollection =>
      FirebaseFirestore.instance.collection(Service.COLLECTION_NAME).withConverter<Service>(
            fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, _) => Service.fromJson(snapshot.data()),
            toFirestore: (Service service, _) => service.toJson(),
          );

  Future<SafeResponse<AppUser>> getCurrentUser() => fetchSafety(() async {
        final currentUser = (await _usersCollection.get(GetOptions(source: Source.server)))
            .docs
            .firstWhere((element) => element.data().userId == _firebaseAuth.currentUser!.uid);
        return currentUser.data();
      });

  Future<SafeResponse> saveService({
    required String serviceName,
    required int moneyAmount,
    required bool isEditMode,
    Service? previousService,
  }) =>
      fetchSafety(
        () async {
          final serviceData = Service(
            id: previousService?.id,
            userId: _userIdentity.currentUser!.userId,
            serviceName: serviceName,
            moneyAmount: moneyAmount,
            date: DateTime.now(),
          );

          await _servicesDao.put(serviceData);
        },
      );

  Future<SafeResponse<List<Service>>> getUserServices() => fetchSafety(
        () async {
          if (kIsWeb) {
            return []; // todo: get from firestore
          } else {
            return await _servicesDao.getAll();
          }
        },
      );
}
