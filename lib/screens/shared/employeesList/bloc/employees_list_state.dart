part of 'employees_list_bloc.dart';

@immutable
abstract class EmployeesListState {}

class EmployeesListStateDefault extends EmployeesListState {
  EmployeesListStateDefault(this.statuses);

  final List<EmployeeStatusModel> statuses;
}

class EmployeesListStateProcessing extends EmployeesListState {}

class EmployeesListStateError extends EmployeesListState {
  EmployeesListStateError(this.error);

  final dynamic error;
}
