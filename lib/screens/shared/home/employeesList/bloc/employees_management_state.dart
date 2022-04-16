part of 'employees_management_bloc.dart';

@immutable
abstract class EmployeesManagementState {}

class EmployeesListStateDefault extends EmployeesManagementState {
  EmployeesListStateDefault._({
    required this.statuses,
    required this.selections,
    required this.payDebit,
  });

  List<Triple<Service, bool, AppUser>> get selectedSelections => selections.where((element) => element.second).toList();

  int get selectedAmount =>
      selectedSelections.map((e) => e.first).fold(0, (previousValue, element) => previousValue + element.moneyAmount);

  int get debitAmount =>
      selectedSelections.map((e) => e.third).fold(0, (previousValue, element) => previousValue + element.debit);

  static EmployeesListStateDefault create(List<EmployeeStatusModel> statuses) => EmployeesListStateDefault._(
        statuses: statuses,
        selections: statuses
            .expand(
              (status) => status.services.map((e) => Triple(e, false, status.user)).toList(),
            )
            .toList(),
        payDebit: false,
      );

  final List<EmployeeStatusModel> statuses;
  final List<Triple<Service, bool, AppUser>> selections;
  final bool payDebit;

  List<Service> filterServicesBy(ServicesModificationMode mode) => mode == ServicesModificationMode.CONFIRMATION
      ? statuses.expand((status) => status.toConfirmation).toList()
      : statuses.expand((status) => status.toPayment).toList();

  EmployeesListStateDefault select(List<Service> services) {
    final newSelections = this.selections;
    services.forEach((service) {
      final selection = this.selections.firstOrNull((element) => element.first == service);
      selection?.second = true;
    });

    return EmployeesListStateDefault._(
      statuses: this.statuses,
      selections: newSelections,
      payDebit: this.payDebit,
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
      payDebit: this.payDebit,
    );
  }

  EmployeesListStateDefault copyWith({bool? payDebit}) => EmployeesListStateDefault._(
        statuses: this.statuses,
        selections: this.selections,
        payDebit: payDebit ?? this.payDebit,
      );
}

class EmployeesListStateProcessing extends EmployeesManagementState {}

class EmployeesListStateSuccess extends EmployeesManagementState {
  EmployeesListStateSuccess(this.transaction);

  final WorkTransaction transaction;
}

class EmployeesListStateError extends EmployeesManagementState {
  EmployeesListStateError(this.error);

  final dynamic error;
}
