import 'dart:async';

import 'package:balu_sto/features/firestore/firestore_repository.dart';
import 'package:balu_sto/features/firestore/models/employee_status.dart';
import 'package:balu_sto/screens/shared/serviceModification/view/services_modification_page.dart';
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
    switch (event) {
      case EmployeesManagementEvent.INIT:
        final employeesResponse = await firestoreRepository.getEmployees();
        if (employeesResponse.isSuccessful) {
          yield EmployeesListStateDefault(employeesResponse.requiredData);
        } else {
          yield EmployeesListStateError(employeesResponse.requiredError);
        }

        break;
    }
  }
}
