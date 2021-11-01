import 'package:balu_sto/features/firestore/firestore_repository.dart';
import 'package:balu_sto/helpers/fetch_helpers.dart';
import 'package:balu_sto/helpers/preferences/preferences_provider.dart';
import 'package:balu_sto/infrastructure/auth/user_identity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthHandler {
  AuthHandler(
    this._firebaseAuth,
    this._preferencesProvider,
    this._userIdentity,
    this._firestoreRepository,
  );

  final FirebaseAuth _firebaseAuth;
  final PreferencesProvider _preferencesProvider;
  final UserIdentity _userIdentity;
  final FirestoreRepository _firestoreRepository;

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
        final currentUserResponse = await _firestoreRepository.getCurrentUser(source: Source.server);
        currentUserResponse.throwIfNotSuccessful();

        _userIdentity.obtainUserData(currentUserResponse.requiredData, false);

        if (!kIsWeb) {
          _firestoreRepository.uploadMissingAssets();
        }

        return currentUserResponse;
      });

  Future<SafeResponse> initOfflineSession() async {
    try {
      final userDataResponse = await _firestoreRepository.getCurrentUser(source: Source.cache);
      userDataResponse.throwIfNotSuccessful();
      _userIdentity.obtainUserData(userDataResponse.requiredData, true);
      return SafeResponse.success(null);
    } catch (e) {
      return SafeResponse.error(e);
    }
  }

  Future logout() async {
    _userIdentity.clear();
  }
}
