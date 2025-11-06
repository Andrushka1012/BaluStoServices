import 'dart:async';
import 'dart:io';

import 'package:balu_sto/features/firestore/firestore_repository.dart';
import 'package:balu_sto/features/firestore/models/popular_services.dart';
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

    try {
      switch (event.runtimeType) {
        case ServiceEventInit:
          yield* _handleInit(previousState);
          break;
        case ServiceEventPrefill:
          yield* _handlePrefill(previousState, event as ServiceEventPrefill);
          break;
        case ServiceEventNameChanged:
          yield previousState.copyWith(
              serviceName: (event as ServiceEventNameChanged).value);
          break;
        case ServiceEventMoneyAmountChanged:
          yield previousState.copyWith(
              moneyAmount: (event as ServiceEventMoneyAmountChanged).value);
          break;
        case ServiceEventApply:
          yield* _saveService(previousState);
          break;
        case ServiceEventTakePhoto:
          yield* _handleTakePhoto(previousState);
          break;
        case ServiceEventRemovePhoto:
          yield* _handleRemovePhoto(previousState);
          break;
        case ServiceEventDelete:
          yield* _handleDelete(previousState);
          break;
      }
    } catch (e, stackTrace) {
      print('ServiceBloc Error: $e');
      print('StackTrace: $stackTrace');
      yield ServiceStateError(
          'Unexpected error: ${e.toString()}\n\nEvent: ${event.runtimeType}');
      yield previousState;
    }
  }

  Stream<ServiceState> _handleInit(DefaultServiceState previousState) async* {
    try {
      yield ServiceStateProcessing();
      final popularServicesResponse =
          await _firestoreRepository.getPopularServices();
      if (popularServicesResponse.isSuccessful) {
        final popularServices = popularServicesResponse.requiredData;
        popularServices.sort(
            (first, second) => first.popularity.compareTo(second.popularity));
        yield previousState.copyWith(
          popularServices: popularServices.reversed.toList(),
        );
      } else {
        yield ServiceStateError(
            'Failed to load popular services: ${popularServicesResponse.requiredError}');
        yield previousState;
      }
    } catch (e, stackTrace) {
      print('Init Error: $e');
      print('StackTrace: $stackTrace');
      yield ServiceStateError('Failed to initialize: ${e.toString()}');
      yield previousState;
    }
  }

  Stream<ServiceState> _handlePrefill(
      DefaultServiceState previousState, ServiceEventPrefill event) async* {
    try {
      yield previousState.copyWith(
        serviceName: event.popularService.name,
        moneyAmount: event.popularService.price?.toString(),
      );
    } catch (e, stackTrace) {
      print('Prefill Error: $e');
      print('StackTrace: $stackTrace');
      yield ServiceStateError(
          'Failed to prefill service data: ${e.toString()}');
      yield previousState;
    }
  }

  Stream<ServiceState> _handleTakePhoto(
      DefaultServiceState previousState) async* {
    try {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.camera);
      if (pickedFile != null) {
        yield previousState.copyWith(photo: File(pickedFile.path));
      }
    } catch (e, stackTrace) {
      print('Take Photo Error: $e');
      print('StackTrace: $stackTrace');
      yield ServiceStateError(
          'Failed to take photo: ${e.toString()}\n\nPlease check camera permissions.');
      yield previousState;
    }
  }

  Stream<ServiceState> _handleRemovePhoto(
      DefaultServiceState previousState) async* {
    try {
      if (previousState.photo != null) {
        await previousState.photo!.delete();
      }
      yield previousState.copyWith()..photo = null;
    } catch (e, stackTrace) {
      print('Remove Photo Error: $e');
      print('StackTrace: $stackTrace');
      yield ServiceStateError('Failed to remove photo: ${e.toString()}');
      yield previousState;
    }
  }

  Stream<ServiceState> _handleDelete(DefaultServiceState previousState) async* {
    try {
      if (previousState.service == null) {
        yield ServiceStateError('Cannot delete: service is null');
        yield previousState;
        return;
      }

      yield ServiceStateProcessing();
      final result =
          await _firestoreRepository.removeService(previousState.service!);
      if (result.isSuccessful) {
        yield ServiceStateSuccess();
      } else {
        yield ServiceStateError(
            'Failed to delete service: ${result.requiredError}');
        yield previousState;
      }
    } catch (e, stackTrace) {
      print('Delete Error: $e');
      print('StackTrace: $stackTrace');
      yield ServiceStateError('Failed to delete service: ${e.toString()}');
      yield previousState;
    }
  }

  Stream<ServiceState> _saveService(DefaultServiceState previousState) async* {
    try {
      // Validate input
      if (previousState.serviceName.trim().isEmpty) {
        yield ServiceStateError('Service name cannot be empty');
        yield previousState;
        return;
      }

      if (previousState.moneyAmount.trim().isEmpty) {
        yield ServiceStateError('Money amount cannot be empty');
        yield previousState;
        return;
      }

      final int? parsedAmount = int.tryParse(previousState.moneyAmount);
      if (parsedAmount == null) {
        yield ServiceStateError(
            'Invalid money amount: "${previousState.moneyAmount}"\n\nPlease enter a valid number');
        yield previousState;
        return;
      }

      if (parsedAmount < 0) {
        yield ServiceStateError('Money amount cannot be negative');
        yield previousState;
        return;
      }

      yield ServiceStateProcessing();
      final saveResult = await _firestoreRepository.saveService(
        serviceId: previousState.serviceId,
        serviceName: previousState.serviceName,
        moneyAmount: parsedAmount,
        isEditMode: previousState.isEditMode,
        previousService: previousState.service,
        photo: previousState.photo,
      );

      if (saveResult.isSuccessful) {
        yield ServiceStateSuccess();
      } else {
        yield ServiceStateError(
            'Failed to save service: ${saveResult.requiredError}');
        yield previousState;
      }
    } catch (e, stackTrace) {
      print('Save Service Error: $e');
      print('StackTrace: $stackTrace');
      yield ServiceStateError('Failed to save service: ${e.toString()}');
      yield previousState;
    }
  }
}
