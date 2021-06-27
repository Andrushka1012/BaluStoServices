import 'dart:async';
import 'dart:io';

import 'package:balu_sto/features/firestore/dao/assets_dao.dart';
import 'package:balu_sto/features/firestore/models/employee_status.dart';
import 'package:balu_sto/features/firestore/models/service.dart';
import 'package:balu_sto/features/firestore/models/service_status.dart';
import 'package:balu_sto/features/firestore/models/transaction.dart';
import 'package:balu_sto/features/firestore/models/user.dart';
import 'package:balu_sto/helpers/extensions/firestore_extensions.dart';
import 'package:balu_sto/helpers/extensions/list_extensions.dart';
import 'package:balu_sto/helpers/extensions/stream_extensions.dart';
import 'package:balu_sto/helpers/fetch_helpers.dart';
import 'package:balu_sto/infrastructure/auth/user_identity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:koin/internals.dart';

class FirestoreRepository {
  FirestoreRepository(this._scope, this._userIdentity);

  final Scope _scope;
  final _firebaseAuth = FirebaseAuth.instance;
  final UserIdentity _userIdentity;
  late final AssetsDao _assetsDao = _scope.get();

  Stream<QuerySnapshot<Service>>? getUserServicesStream(String userId) =>
      flattenStreams(_getUserServicesCollection(userId).asStream().map((event) => event.snapshots()));

  CollectionReference<AppUser> get _usersCollection =>
      FirebaseFirestore.instance.collection(AppUser.COLLECTION_NAME).userConverter();

  CollectionReference<Service> get _currentUserServicesCollection => _usersCollection
      .doc(_userIdentity.currentUser?.documentId)
      .collection(Service.COLLECTION_NAME)
      .serviceConverter();

  CollectionReference<WorkTransaction> get _transactionsCollection =>
      FirebaseFirestore.instance.collection(WorkTransaction.COLLECTION_NAME).workTransactionConverter();

  Future<CollectionReference<Service>> _getUserServicesCollection(String userId) async {
    final userDocumentId = (await _usersCollection.where('userId', isEqualTo: userId).get()).docs.first.id;

    return _usersCollection.doc(userDocumentId).collection(Service.COLLECTION_NAME).serviceConverter();
  }

  Future<QueryDocumentSnapshot<Service>> _getUserService(String userId, String serviceId) async {
    final userServicesCollection = await _getUserServicesCollection(userId);
    return (await userServicesCollection.where('id', isEqualTo: serviceId).get()).docs.first;
  }

  Future<SafeResponse<AppUser>> getCurrentUser({Source source = Source.server}) => fetchSafety(() async {
        final currentUserDoc = (await _usersCollection.get(GetOptions(source: source)))
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
          );

          try {
            if (isEditMode) {
              final serviceDocument = await _getUserService(previousService!.userId, previousService.id);
              await serviceDocument.reference.update(serviceData.toJsonApi()).timeout(Duration(seconds: 5));
            } else {
              await _currentUserServicesCollection.add(serviceData).timeout(Duration(seconds: 5));
            }
          } catch (e) {
            print('Service upload error');
            print(e);
          }

          try {
            if (photo != null) {
              final storageRef = FirebaseStorage.instance.ref().child('services/$serviceId');
              await storageRef.putFile(photo).timeout(Duration(seconds: 10));
            }
          } catch (e) {
            print('Service photo upload error');
            print(e);
            await _assetsDao.put(AssetModel(assetPath: 'services/$serviceId', filePath: photo!.path));
          }
        },
      );

  Future<SafeResponse<List<Service>>> getCurrentUserServices() => fetchSafety(
        () async {
          final services = (await _currentUserServicesCollection.get()).docs.map((e) => e.data()).toList();
          return services;
        },
      );

  Future<SafeResponse> removeService(Service service) => fetchSafety(
        () async {
          final serviceRef = await _getUserService(service.userId, service.id);

          await serviceRef.reference.delete().timeout(Duration(seconds: 5));

          try {
            if (service.hasPhoto) {
              final storageRef = FirebaseStorage.instance.ref().child('services/${service.id}');
              await storageRef.delete();
            }
          } catch (e) {
            print(e);
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

  Future<SafeResponse> updateServices(List<Service> services, Transaction? transaction) => fetchSafety(
        () async {
          await Future.wait(
            services.map((service) async {
              final serviceDocument = await _getUserService(service.userId, service.id);

              if (transaction != null) {
                transaction.set(serviceDocument.reference, service.toJsonApi());
              } else {
                await serviceDocument.reference.update(service.toJsonApi()).timeout(Duration(seconds: 5));
              }
            }),
          );
        },
      );

  Future<SafeResponse> uploadMissingAssets() => fetchSafety(
        () async {
          final assets = await _assetsDao.getAll();

          await Future.wait(
            assets.map((asset) async {
              final assetFile = File(asset.filePath);
              if (assetFile.existsSync()) {
                try {
                  final storageRef = FirebaseStorage.instance.ref().child(asset.assetPath);
                  await storageRef.putFile(assetFile);

                  await _assetsDao.remove(asset);
                } catch (e) {
                  print('Service photo upload error');
                  print(e);
                }
              }
            }),
          );
        },
      );

  Future<SafeResponse> performTransaction(List<Service> services, ServiceStatus status) => fetchSafety(
        () async {
          await FirebaseFirestore.instance.runTransaction((transaction) async {
            await updateServices(services, transaction);

            final servicesGroups = services
                .groupBy((item) => item.userId)
                .entries
                .map(
                  (group) => TransactionMember(
                    userId: group.key,
                    services: group.value.map((e) => e.id).toList(),
                  ),
                )
                .toList();

            final workTransaction = WorkTransaction(
              members: servicesGroups,
              date: DateTime.now(),
              status: status,
            );

            final transactionDocument = _transactionsCollection.doc(workTransaction.id);

            transaction.set(transactionDocument, workTransaction);
          });
        },
      );
}
