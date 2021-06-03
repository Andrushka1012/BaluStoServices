import 'package:balu_sto/features/account/models/user.dart';
import 'package:balu_sto/helpers/fetch_helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountRepository {
  final _firebaseAuth = FirebaseAuth.instance;

  CollectionReference<AppUser> get _usersCollection =>
      FirebaseFirestore.instance.collection(AppUser.COLLECTION_NAME).withConverter<AppUser>(
            fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, _) => AppUser.fromJson(snapshot.data()),
            toFirestore: (AppUser user, _) => user.toJson(),
          );

  Future<SafeResponse<AppUser>> getCurrentUser() => fetchSafety(() async {
        final currentUser = (await _usersCollection.get())
            .docs
            .firstWhere((element) => element.data().userId == _firebaseAuth.currentUser!.uid);
        return currentUser.data();
      });
}
