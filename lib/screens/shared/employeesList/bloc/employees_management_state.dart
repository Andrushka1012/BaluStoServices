part of 'employees_management_bloc.dart';

@immutable
abstract class EmployeesManagementState {}

class EmployeesListStateDefault extends EmployeesManagementState {
  EmployeesListStateDefault._({
    required this.statuses,
    required this.selections,
  });

  static EmployeesListStateDefault create(List<EmployeeStatusModel> statuses) => EmployeesListStateDefault._(
        statuses: statuses,
        selections: statuses
            .expand(
              (status) => status.services.map((e) => Pair(e, false)).toList(),
            )
            .toList(),
      );

  final List<EmployeeStatusModel> statuses;
  final List<Pair<Service, bool>> selections;

  EmployeesListStateDefault select(List<Service> services) {
    final newSelections = this.selections;
    services.forEach((service) {
      final selection = this.selections.firstOrNull((element) => element.first == service);
      selection?.second = true;
    });


    return EmployeesListStateDefault._(
      statuses: this.statuses,
      selections: newSelections,
    );
  }

  EmployeesListStateDefault unselect(List<Service> services) {
    final newSelections = this.selections;
    services.forEach((service) {
      final selection = this.selections.firstOrNull((element) => element.first == service);
      selection?.second = false;
    });


    return EmployeesListStateDefault._(
      statuses: this.statuses,
      selections: newSelections,
    );
  }
}

class EmployeesListStateProcessing extends EmployeesManagementState {}

class EmployeesListStateError extends EmployeesManagementState {
  EmployeesListStateError(this.error);

  final dynamic error;
}
