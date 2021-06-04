import 'package:balu_sto/features/firestore/models/user.dart';

class UserIdentity {
  AppUser? currentUser;
  bool? offlineMode;

  void obtainUserData(AppUser user, bool offlineMode) {
    currentUser = user;
    this.offlineMode = offlineMode;
    print('init:\n${user.toJsonApi()}');
    print('offline: $offlineMode');
  }

  void clear() {
    print('clear session');
    currentUser = null;
    offlineMode = null;
  }
}
