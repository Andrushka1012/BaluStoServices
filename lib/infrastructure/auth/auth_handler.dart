import 'package:balu_sto/helpers/fetch_helpers.dart';
import 'package:balu_sto/helpers/preferences/preferences_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthHandler {
  AuthHandler(this._firebaseAuth, this._preferencesProvider);

  final FirebaseAuth _firebaseAuth;
  final PreferencesProvider _preferencesProvider;

  Future<SafeResponse<UserCredential>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      fetchSafety(() async {
        final result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        _preferencesProvider.prefillEmail.value = email;

        return result;
      });
}
