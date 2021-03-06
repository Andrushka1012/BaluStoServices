import 'dart:async';

import 'package:balu_sto/features/firestore/firestore_repository.dart';
import 'package:balu_sto/features/firestore/models/employee_status.dart';
import 'package:balu_sto/features/firestore/models/service.dart';
import 'package:balu_sto/features/firestore/models/service_status.dart';
import 'package:balu_sto/features/firestore/models/transaction.dart';
import 'package:balu_sto/features/firestore/models/user.dart';
import 'package:balu_sto/helpers/extensions/list_extensions.dart';
import 'package:balu_sto/helpers/triple.dart';
import 'package:balu_sto/screens/shared/home/serviceModification/view/services_modification_page.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'employees_management_event.dart';
part 'employees_management_state.dart';

class EmployeesManagementBloc extends Bloc<EmployeesManagementEvent, EmployeesManagementState> {
  EmployeesManagementBloc({
    required this.firestoreRepository,
    this.mode,
    this.userId,
  }) : super(EmployeesListStateProcessing());

  final ServicesModificationMode? mode;
  final String? userId;
  final FirestoreRepository firestoreRepository;

  @override
  Stream<EmployeesManagementState> mapEventToState(EmployeesManagementEvent event) async* {
    switch (event.runtimeType) {
      case EmployeesManagementEventInit:
        yield* _init();
        break;
      case EmployeesManagementEventSelect:
        final EmployeesManagementEventSelect selectEvent = event as EmployeesManagementEventSelect;
        final currentState = state;
        if (currentState is EmployeesListStateDefault) {
          yield (currentState).select(selectEvent.services);
        }
        break;
      case EmployeesManagementEventUnselect:
        final EmployeesManagementEventUnselect unselectEvent = event as EmployeesManagementEventUnselect;
        final currentState = state;
        if (currentState is EmployeesListStateDefault) {
          yield (currentState).unselect(unselectEvent.services);
        }
        break;
      case EmployeesManagementEventApply:
        if (mode != null) {
          yield* apply();
        }
        break;
      case EmployeesManagementEventUpdateState:
        final currentState = state;
        if (currentState is EmployeesListStateDefault) {
          yield currentState.copyWith(
            payDebit: (event as EmployeesManagementEventUpdateState).payDebit,
          );
        }
        break;
    }
  }

  Stream<EmployeesManagementState> _init() async* {
    try {
      final List<EmployeeStatusModel> employees;

      if (userId != null) {
        final employeeResponse = await firestoreRepository.getEmployeeStatus(userId!);
        employeeResponse.throwIfNotSuccessful();
        employees = [employeeResponse.requiredData];
      } else {
        final employeesResponse = await firestoreRepository.getEmployees();
        employeesResponse.throwIfNotSuccessful();
        employees = employeesResponse.requiredData;
      }

      yield EmployeesListStateDefault.create(employees);
    } catch (e) {
      yield EmployeesListStateError(e);
    }
  }

  Stream<EmployeesManagementState> apply() async* {
    final previousState = state;
    if (previousState is EmployeesListStateDefault) {
      yield EmployeesListStateProcessing();

      final selectedServices = previousState.selectedSelections.map((triple) => triple.first).toList();

      final status = mode == ServicesModificationMode.CONFIRMATION ? ServiceStatus.CONFIRMED : ServiceStatus.PAYED;

      selectedServices.forEach((service) {
        service.status = status;
      });

      final updateResult = await firestoreRepository.performTransaction(
        selectedServices,
        status,
        payDebits: previousState.payDebit,
      );
      if (updateResult.isSuccessful) {
        yield EmployeesListStateSuccess(updateResult.requiredData);
      } else {
        yield EmployeesListStateError(updateResult.requiredError);
        yield* _init();
      }
    }
  }
}
