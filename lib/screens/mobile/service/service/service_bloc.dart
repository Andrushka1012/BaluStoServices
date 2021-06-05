import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:balu_sto/features/firestore/firestore_repository.dart';
import 'package:balu_sto/features/firestore/models/service.dart';
import 'package:balu_sto/helpers/pair.dart';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'service_event.dart';

part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  ServiceBloc(
    Pair<Service?, bool> args,
    this._firestoreRepository,
  ) : super(DefaultServiceState.create(
          args.first,
          args.second,
        ));

  final FirestoreRepository _firestoreRepository;

  @override
  Stream<ServiceState> mapEventToState(ServiceEvent event) async* {
    if (state is! DefaultServiceState) return;
    final DefaultServiceState previousState = state as DefaultServiceState;

    switch (event.runtimeType) {
      case ServiceEventNameChanged:
        yield previousState.copyWith(serviceName: (event as ServiceEventNameChanged).value);
        break;
      case ServiceEventMoneyAmountChanged:
        yield previousState.copyWith(moneyAmount: (event as ServiceEventMoneyAmountChanged).value);
        break;
      case ServiceEventApply:
        yield* _saveService(previousState);
        break;
      case ServiceEventTakePhoto:
        final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
        if (pickedFile != null) {
          yield previousState.copyWith(photo: File(pickedFile.path));
        }
        break;
      case ServiceEventRemovePhoto:
        yield previousState.copyWith()..photo = null;
        break;
      case ServiceEventDelete:
        final result = await _firestoreRepository.removeService(previousState.service!);
        if (result.isSuccessful) {
          yield ServiceStateSuccess();
        } else {
          yield ServiceStateError(result.requiredError, false);
          yield previousState;
        }
        break;
    }
  }

  Stream<ServiceState> _saveService(DefaultServiceState previousState) async* {
    try {
      yield ServiceStateProcessing();
      final saveResult = await _firestoreRepository.saveService(
          serviceId: previousState.serviceId,
          serviceName: previousState.serviceName,
          moneyAmount: int.parse(previousState.moneyAmount),
          isEditMode: previousState.isEditMode,
          previousService: previousState.service,
          photo: previousState.photo);
      if (saveResult.isSuccessful) {
        yield ServiceStateSuccess();
      } else {
        yield ServiceStateError(saveResult.requiredError, true);
        yield previousState;
      }
    }catch(e) {
      yield ServiceStateError(e, false);
      yield previousState;
    }
  }
}
