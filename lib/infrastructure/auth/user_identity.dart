import 'package:balu_sto/features/account/models/user.dart';

class UserIdentity{

  AppUser? currentUser;

  void obtainUserData(AppUser user) {
    currentUser = user;
  }

  void clear() {
    currentUser = null;
  }

}