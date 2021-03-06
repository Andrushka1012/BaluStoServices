import 'dart:async';

import 'package:balu_sto/features/firestore/models/role.dart';
import 'package:balu_sto/features/firestore/models/user.dart';
import 'package:balu_sto/helpers/preferences/preferences_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:meta/meta.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc(this._firebaseAuth, this._firestore, this._preferencesProvider) : super(RegistrationStateInput());

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final PreferencesProvider _preferencesProvider;

  @override
  Stream<RegistrationState> mapEventToState(RegistrationEvent event) async* {
    if (state is! RegistrationStateInput) return;
    final RegistrationStateInput inputState = state as RegistrationStateInput;

    switch (event.runtimeType) {
      case RegistrationEventNameChanged:
        yield inputState.copyWith(name: (event as RegistrationEventNameChanged).value);
        break;
      case RegistrationEventEmailChanged:
        yield inputState.copyWith(email: (event as RegistrationEventEmailChanged).value);
        break;
      case RegistrationEventPasswordChanged:
        yield inputState.copyWith(password: (event as RegistrationEventPasswordChanged).value);
        break;
      case RegistrationEventCreate:
        yield* _registerAccount(inputState);
        break;
    }
  }

  Stream<RegistrationState> _registerAccount(RegistrationStateInput inputState) async* {
    try {
      if (inputState.name.length <= 1) {
        throw 'Неправильное имя';
      }

      yield RegistrationStateProcessing();
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: inputState.email,
        password: inputState.password,
      );

      await _firebaseAuth.signInWithEmailAndPassword(
        email: inputState.email,
        password: inputState.password,
      );

      final AppUser user = AppUser(
        userId: _firebaseAuth.currentUser!.uid,
        name: inputState.name,
        email: inputState.email,
        role: Role.EMPLOYEE,
        debit: 0,
      );

      _firestore
          .collection(AppUser.COLLECTION_NAME)
          .add(user.toJsonApi())
          .then((value) => print('Account created'))
          .catchError((e) {
        print('Account creation error $e');
      });

      await _firebaseAuth.signOut();
      if (kIsWeb) {
        await Future.delayed(Duration(seconds: 3)); // Delay because of firebase firestore issue
      }

      _preferencesProvider.prefillEmail.value = inputState.email;
      yield RegistrationStateRegistered();
    } catch (e) {
      print(e);
      yield RegistrationStateError(e);
      yield inputState.copyWith();
    }
  }
}
