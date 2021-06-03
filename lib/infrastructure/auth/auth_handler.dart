import 'package:balu_sto/features/account/account_repository.dart';
import 'package:balu_sto/helpers/fetch_helpers.dart';
import 'package:balu_sto/helpers/preferences/preferences_provider.dart';
import 'package:balu_sto/infrastructure/auth/user_identity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthHandler {
  AuthHandler(this._firebaseAuth, this._preferencesProvider, this._userIdentity, this._accountRepository);

  final FirebaseAuth _firebaseAuth;
  final PreferencesProvider _preferencesProvider;
  final UserIdentity _userIdentity;
  final AccountRepository _accountRepository;

  Future<SafeResponse> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      fetchSafety(() async {
        final result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        _preferencesProvider.prefillEmail.value = email;

        (await initSession()).throwIfNotSuccessful();
      });

  Future<SafeResponse> initSession() async {
    final currentUserResponse = await _accountRepository.getCurrentUser();
    currentUserResponse.throwIfNotSuccessful();

    _userIdentity.obtainUserData(currentUserResponse.requiredData);

    return SafeResponse.success('');
  }
}
