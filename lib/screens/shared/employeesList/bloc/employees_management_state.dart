part of 'employees_management_bloc.dart';

@immutable
abstract class EmployeesManagementState {}

class EmployeesListStateDefault extends EmployeesManagementState {
  EmployeesListStateDefault(this.statuses);

  final List<EmployeeStatusModel> statuses;
}

class EmployeesListStateProcessing extends EmployeesManagementState {}

class EmployeesListStateError extends EmployeesManagementState {
  EmployeesListStateError(this.error);

  final dynamic error;
}
