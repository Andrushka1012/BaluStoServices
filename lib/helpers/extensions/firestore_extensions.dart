import 'package:balu_sto/features/firestore/models/popular_services.dart';
import 'package:balu_sto/features/firestore/models/service.dart';
import 'package:balu_sto/features/firestore/models/transaction.dart';
import 'package:balu_sto/features/firestore/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

extension FiestoreCollectionExtensions on CollectionReference<Map<String, dynamic>> {
  CollectionReference<Service> serviceConverter() => this.withConverter<Service>(
        fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, _) => Service.fromJson(snapshot.data()),
        toFirestore: (Service service, _) => service.toJsonApi(),
      );

  CollectionReference<AppUser> userConverter() => this.withConverter<AppUser>(
        fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, _) => AppUser.fromJson(snapshot.data()),
        toFirestore: (AppUser user, _) => user.toJsonApi(),
      );

  CollectionReference<WorkTransaction> workTransactionConverter() => this.withConverter<WorkTransaction>(
        fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, _) =>
            WorkTransaction.fromJson(snapshot.data()),
        toFirestore: (WorkTransaction transaction, _) => transaction.toJsonApi(),
      );

  CollectionReference<PopularServices> popularServiceConverter() => this.withConverter<PopularServices>(
        fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, _) =>
            PopularServices.fromJson(snapshot.data()),
        toFirestore: (PopularServices service, _) => service.toJsonApi(),
      );
}
