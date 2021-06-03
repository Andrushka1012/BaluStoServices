import 'package:balu_sto/features/firestore/dao/services_dao.dart';
import 'package:balu_sto/features/firestore/firestore_repository.dart';
import 'package:balu_sto/features/firestore/dao/current_user_dao.dart';
import 'package:balu_sto/helpers/fetch_helpers.dart';
import 'package:balu_sto/helpers/preferences/preferences_provider.dart';
import 'package:balu_sto/infrastructure/auth/user_identity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:koin/internals.dart';

class AuthHandler {
  AuthHandler(
    this._scope,
    this._firebaseAuth,
    this._preferencesProvider,
    this._userIdentity,
    this._firestoreRepository,
  );

  final Scope _scope;
  final FirebaseAuth _firebaseAuth;
  final PreferencesProvider _preferencesProvider;
  final UserIdentity _userIdentity;
  final FirestoreRepository _firestoreRepository;

  late final CurrentUserDao _currentUserDao = _scope.get();
  late final ServicesDao _servicesDao = _scope.get();

  Future<SafeResponse> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      fetchSafety(() async {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        _preferencesProvider.prefillEmail.value = email;

        final initializationResult = await initOnlineSession();
        initializationResult.throwIfNotSuccessful();
      });

  Future<SafeResponse> initSession() => fetchSafety(() async {
        final initializationResult = await initOnlineSession();

        if (!kIsWeb && initializationResult.isFailure) {
          final offlineInitializationResult = await initOfflineSession();
          offlineInitializationResult.throwIfNotSuccessful();
        } else {
          initializationResult.throwIfNotSuccessful();
        }
        return initializationResult;
      });

  Future<SafeResponse> initOnlineSession() => fetchSafety(() async {
        final currentUserResponse = await _firestoreRepository.getCurrentUser();
        currentUserResponse.throwIfNotSuccessful();

        if (!kIsWeb) {
          _currentUserDao.put(currentUserResponse.requiredData);
        }

        _userIdentity.obtainUserData(currentUserResponse.requiredData, false);

        return currentUserResponse;
      });

  Future<SafeResponse> initOfflineSession() async {
    try {
      final userData = await _currentUserDao.getCurrentUser();
      _userIdentity.obtainUserData(userData!, true);
      return SafeResponse.success(null);
    } catch (e) {
      return SafeResponse.error(e);
    }
  }

  Future logout() async {
    await _currentUserDao.removeAll();
    await _servicesDao.removeAll();
  }
}
