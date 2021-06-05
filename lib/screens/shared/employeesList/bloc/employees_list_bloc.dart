import 'dart:async';

import 'package:balu_sto/features/firestore/firestore_repository.dart';
import 'package:balu_sto/features/firestore/models/employee_status.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'employees_list_event.dart';

part 'employees_list_state.dart';

class EmployeesListBloc extends Bloc<EmployeesListEvent, EmployeesListState> {
  EmployeesListBloc(this._firestoreRepository) : super(EmployeesListStateProcessing());

  final FirestoreRepository _firestoreRepository;

  @override
  Stream<EmployeesListState> mapEventToState(EmployeesListEvent event) async* {
    switch (event) {
      case EmployeesListEvent.INIT:
        final employeesResponse = await _firestoreRepository.getEmployees();
        if (employeesResponse.isSuccessful) {
          yield EmployeesListStateDefault(employeesResponse.requiredData);
        } else {
          yield EmployeesListStateError(employeesResponse.requiredError);
        }

        break;
    }
  }
}
