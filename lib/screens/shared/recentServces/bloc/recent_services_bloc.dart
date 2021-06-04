import 'dart:async';

import 'package:balu_sto/features/firestore/firestore_repository.dart';
import 'package:balu_sto/features/firestore/models/service.dart';
import 'package:balu_sto/helpers/extensions/list_extensions.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'recent_services_event.dart';

part 'recent_services_state.dart';

class RecentServicesBloc extends Bloc<RecentServicesEvent, RecentServicesState> {
  RecentServicesBloc(this._firestoreRepository) : super(InitialRecentServicesState()) {
    _servicesSubscription = _firestoreRepository.servicesStream?.listen((_) => add(RecentServicesEvent.INIT));
  }

  final FirestoreRepository _firestoreRepository;
  StreamSubscription? _servicesSubscription;

  @override
  Stream<RecentServicesState> mapEventToState(RecentServicesEvent event) async* {
    switch (event) {
      case RecentServicesEvent.INIT:
        final servicesResponse = await _firestoreRepository.getUserServices();

        if (servicesResponse.isSuccessful) {
          servicesResponse.requiredData.sort((first, second) => first.date.compareTo(second.date));
          yield RecentServicesStateDataReady(servicesResponse.requiredData.reversed.toList().innerList(0, 4));
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
