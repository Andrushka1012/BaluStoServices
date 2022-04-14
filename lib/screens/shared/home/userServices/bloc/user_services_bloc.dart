import 'dart:async';

import 'package:balu_sto/features/firestore/firestore_repository.dart';
import 'package:balu_sto/features/firestore/models/service.dart';
import 'package:balu_sto/features/firestore/models/service_status.dart';
import 'package:balu_sto/features/firestore/models/user.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'user_services_event.dart';
part 'user_services_state.dart';

class RecentServicesBloc extends Bloc<UserServicesEvent, UserServicesState> {
  RecentServicesBloc(this.userId, this._firestoreRepository) : super(InitialRecentServicesState()) {
    _servicesSubscription = _firestoreRepository.getUserServicesStream(userId)?.listen((_) => add(UserServicesEvent.INIT));
  }

  final String userId;
  final FirestoreRepository _firestoreRepository;
  StreamSubscription? _servicesSubscription;

  @override
  Stream<UserServicesState> mapEventToState(UserServicesEvent event) async* {
    switch (event) {
      case UserServicesEvent.INIT:
        final servicesResponse = await _firestoreRepository.getUserServices(userId);
        final userDataResponse = await _firestoreRepository.getUser(userId);

        if (servicesResponse.isSuccessful && userDataResponse.isSuccessful) {
          servicesResponse.requiredData.sort((first, second) => first.date.compareTo(second.date));
          yield UserServicesStateDataReady(
            servicesResponse.requiredData.reversed.toList(),
            userDataResponse.requiredData,
          );
        }
        break;
    }
  }

  @override
  Future<void> close() {
    _servicesSubscription?.cancel();
    return super.close();
  }
}
