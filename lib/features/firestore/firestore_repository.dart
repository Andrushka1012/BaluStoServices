import 'dart:async';
import 'dart:io';

import 'package:balu_sto/features/firestore/dao/services_dao.dart';
import 'package:balu_sto/features/firestore/models/employee_status.dart';
import 'package:balu_sto/features/firestore/models/service.dart';
import 'package:balu_sto/features/firestore/models/service_status.dart';
import 'package:balu_sto/features/firestore/models/user.dart';
import 'package:balu_sto/helpers/extensions/firestore_extensions.dart';
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
      FirebaseFirestore.instance.collection(AppUser.COLLECTION_NAME).userConverter();

  CollectionReference<Service> get _currentUserServicesCollection => _usersCollection
      .doc(_userIdentity.currentUser?.documentId)
      .collection(Service.COLLECTION_NAME)
      .serviceConverter();

  Future<CollectionReference<Service>> _getUserServicesCollection(String userId) async {
    final userDocumentId = (await _usersCollection.where('userId', isEqualTo: userId).get()).docs.first.id;

    return _usersCollection.doc(userDocumentId).collection(Service.COLLECTION_NAME).serviceConverter();
  }

  Future<QueryDocumentSnapshot<Service>> _getUserService(String userId, String serviceId) async {
    final userServicesCollection = await _getUserServicesCollection(userId);
    return (await userServicesCollection.where('id', isEqualTo: serviceId).get()).docs.first;
  }

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
            status: ServiceStatus.NOT_CONFIRMED,
            date: previousService?.date ?? DateTime.now(),
            modifiedDate: isEditMode ? DateTime.now() : null,
            hasPhoto: previousService?.hasPhoto ?? photo != null,
            localData: ServiceLocalData(
                filePath: photo?.path ?? previousService?.localData?.filePath,
                isUploaded: false,
                documentId: previousService?.localData?.documentId),
          );

          await _servicesDao.put(serviceData);
          String? documentId;

          try {
            if (isEditMode) {
              documentId = previousService?.localData?.documentId!;
              _currentUserServicesCollection
                  .doc(documentId)
                  .update(serviceData.toJsonApi())
                  .timeout(Duration(seconds: 3));
            } else {
              final documentRef = await _currentUserServicesCollection.add(serviceData).timeout(Duration(seconds: 3));
              documentId = documentRef.id;
            }
          } catch (e) {
            if (isEditMode) {
              await _servicesDao.put(previousService!);
            } else {
              await _servicesDao.removeByKey(serviceId);
            }
            rethrow;
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

  Future<SafeResponse<List<Service>>> getCurrentUserServices({bool fromRemote = false}) => fetchSafety(
        () async {
          if (kIsWeb || fromRemote) {
            final services = (await _currentUserServicesCollection.get(GetOptions(source: Source.server)))
                .docs
                .map((e) => e.data())
                .toList();
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
          final servicesDataResponse = await getCurrentUserServices(fromRemote: true);
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
            await _currentUserServicesCollection
                .doc(service.localData?.documentId)
                .delete()
                .timeout(Duration(seconds: 3));
          }

          if (service.hasPhoto) {
            final storageRef = FirebaseStorage.instance.ref().child('services/${service.id}');
            await storageRef.delete();
          }
        },
      );

  Future<SafeResponse<List<Service>>> getUserServices(String userId) => fetchSafety(
        () async {
          if (userId == _userIdentity.currentUser?.userId) {
            final servicesResponse = await getCurrentUserServices();
            servicesResponse.throwIfNotSuccessful();
            return servicesResponse.requiredData;
          } else {
            assert(_userIdentity.isAdmin, 'Вы можете просматривать только свои услуги');
            final collection = await _getUserServicesCollection(userId);
            final services = (await collection.get()).docs.map((e) => e.data()).toList();

            return services;
          }
        },
      );

  Future<SafeResponse<List<EmployeeStatusModel>>> getEmployees() => fetchSafety(
        () async {
          assert(_userIdentity.isAdmin, 'Это доступно только администратору');
          final usersDocuments = await _usersCollection.get();

          final List<EmployeeStatusModel> statuses = [];

          await Future.wait(
            usersDocuments.docs.map(
              (document) async {
                final employeeResponse = await getEmployeeStatus(document.data().userId);
                employeeResponse.throwIfNotSuccessful();
                statuses.add(employeeResponse.requiredData);
              },
            ),
          );

          print(statuses);
          return statuses;
        },
      );

  Future<SafeResponse<EmployeeStatusModel>> getEmployeeStatus(String userId) => fetchSafety(
        () async {
          final userDocument = (await _usersCollection.where('userId', isEqualTo: userId).get()).docs.first;
          final userData = userDocument.data();

          final userServicesCollection = await _getUserServicesCollection(userId);
          final services = (await userServicesCollection.get()).docs.map((e) => e.data()).toList();

          services.sort((first, second) => first.date.compareTo(second.date));

          return EmployeeStatusModel(
            user: userData,
            services: services.reversed.toList(),
          );
        },
      );

  Future<SafeResponse> updateServices(List<Service> services) => fetchSafety(
        () async {
          await Future.wait(
            services.map((service) async {
              final serviceDocument = await _getUserService(service.userId, service.id);
              await serviceDocument.reference.update(service.toJsonApi()).timeout(Duration(seconds: 3));
            }),
          );

          if (!kIsWeb) {
            await syncUserServices();
          }
        },
      );
}
