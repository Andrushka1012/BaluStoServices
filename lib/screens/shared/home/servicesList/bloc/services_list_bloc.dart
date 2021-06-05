import 'dart:async';

import 'package:balu_sto/features/firestore/firestore_repository.dart';
import 'package:balu_sto/features/firestore/models/service.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'services_list_event.dart';

part 'services_list_state.dart';

class ServicesListBloc extends Bloc<ServicesListEvent, ServicesListState> {
  ServicesListBloc(this.userId, this._firestoreRepository) : super(ServicesListStateProcessing()) {
    _servicesSubscription = _firestoreRepository.servicesStream?.listen((_) => add(ServicesListEvent.INIT));
  }

  final String userId;
  final FirestoreRepository _firestoreRepository;

  StreamSubscription? _servicesSubscription;

  @override
  Stream<ServicesListState> mapEventToState(ServicesListEvent event) async* {
    switch (event) {
      case ServicesListEvent.INIT:
        yield ServicesListStateProcessing();
        final servicesResponse = await _firestoreRepository.getCurrentUserServices();
        if (servicesResponse.isSuccessful) {
          yield ServicesListStateData(servicesResponse.requiredData);
        } else {
          yield ServicesListStateError(servicesResponse.requiredError);
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
