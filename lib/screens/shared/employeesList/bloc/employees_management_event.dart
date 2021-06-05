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
