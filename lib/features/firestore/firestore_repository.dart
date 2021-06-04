import 'dart:async';
import 'dart:io';

import 'package:balu_sto/features/firestore/dao/services_dao.dart';
import 'package:balu_sto/features/firestore/models/service.dart';
import 'package:balu_sto/features/firestore/models/user.dart';
import 'package:balu_sto/helpers/fetch_helpers.dart';
import 'package:balu_sto/infrastructure/auth/user_identity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
            toFirestore: (AppUser user, _) => user.toJsonApi(),
          );

  CollectionReference<Service> get _servicesCollection => _usersCollection
      .doc(_userIdentity.currentUser?.documentId)
      .collection(Service.COLLECTION_NAME)
      .withConverter<Service>(
        fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, _) => Service.fromJson(snapshot.data()),
        toFirestore: (Service service, _) => service.toJsonApi(),
      );

  Future<SafeResponse<AppUser>> getCurrentUser() => fetchSafety(() async {
        final currentUserDoc = (await _usersCollection.get(GetOptions(source: Source.server)))
            .docs
            .firstWhere((element) => element.data().userId == _firebaseAuth.currentUser!.uid);
        return currentUserDoc.data()..documentId = currentUserDoc.id;
      });

  Future<SafeResponse> saveService({
    required String serviceId,
    required String serviceName,
    required int moneyAmount,
    required bool isEditMode,
    Service? previousService,
    File? photo,
  }) =>
      fetchSafety(
        () async {
          final serviceData = Service(
            id: serviceId,
            userId: _userIdentity.currentUser!.userId,
            serviceName: serviceName,
            moneyAmount: moneyAmount,
            date: previousService?.date ?? DateTime.now(),
            modifiedDate: isEditMode ? DateTime.now() : null,
            hasPhoto: photo != null,
            localData: ServiceLocalData(
                filePath: photo?.path ?? previousService?.localData?.filePath,
                isUploaded: false,
                documentId: previousService?.localData?.documentId),
          );

          await _servicesDao.put(serviceData);

          String? documentId;
          if (isEditMode) {
            documentId = previousService?.localData?.documentId!;
            _servicesCollection.doc(documentId).update(serviceData.toJsonApi()).timeout(Duration(seconds: 3));
          } else {
            final documentRef = await _servicesCollection.add(serviceData).timeout(Duration(seconds: 3));
            documentId = documentRef.id;
          }

          serviceData.localData?.documentId = documentId;
          await _servicesDao.put(serviceData);

          if (photo != null) {
            final storageRef = FirebaseStorage.instance.ref().child('services/$serviceId');
            final task = await storageRef.putFile(photo);
            final downloadUrl = await task.ref.getDownloadURL();
            print(downloadUrl);
            print(serviceId);
          }

          serviceData.localData?.isUploaded = true;
          await _servicesDao.put(serviceData);
        },
      );

  Future<SafeResponse<List<Service>>> getUserServices({bool fromRemote = false}) => fetchSafety(
        () async {
          if (kIsWeb || fromRemote) {
            final services =
                (await _servicesCollection.get(GetOptions(source: Source.server))).docs.map((e) => e.data()).toList();
            return services;
          } else {
            final services = await _servicesDao.getAll();
            return services.where((element) => element.userId == _userIdentity.currentUser?.userId).toList();
          }
        },
      );

  Future<SafeResponse> syncUserServices() => fetchSafety(
        () async {
          assert(!kIsWeb, 'Method not available on web');
          final servicesDataResponse = await getUserServices(fromRemote: true);
          servicesDataResponse.throwIfNotSuccessful();

          final services = servicesDataResponse.requiredData;

          await Future.forEach(services, (Service service) async {
            final localService = await _servicesDao.getBy(service.id);
            if (localService != null) {
              service.localData = localService.localData;
            }
          });

          await _servicesDao.putAll(servicesDataResponse.requiredData);
        },
      );

  Future<SafeResponse> removeService(Service service) => fetchSafety(
        () async {
          if (!kIsWeb) {
            await _servicesDao.remove(service);
          }
          if (service.localData?.documentId != null) {
            await _servicesCollection.doc(service.localData?.documentId).delete().timeout(Duration(seconds: 3));
          }

          if (service.hasPhoto) {
            final storageRef = FirebaseStorage.instance.ref().child('services/${service.id}');
            await storageRef.delete();
          }
        },
      );
}
