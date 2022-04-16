part of 'employees_management_bloc.dart';

abstract class EmployeesManagementEvent {}

class EmployeesManagementEventInit extends EmployeesManagementEvent {}

class EmployeesManagementEventSelect extends EmployeesManagementEvent {
  EmployeesManagementEventSelect(this.services);

  List<Service> services;
}

class EmployeesManagementEventUnselect extends EmployeesManagementEvent {
  EmployeesManagementEventUnselect(this.services);

  List<Service> services;
}

class EmployeesManagementEventApply extends EmployeesManagementEvent {}

class EmployeesManagementEventUpdateState extends EmployeesManagementEvent {
  final bool payDebit;

  EmployeesManagementEventUpdateState({required this.payDebit});
}