part of 'services_list_bloc.dart';

@immutable
abstract class ServicesListState {}

class ServicesListStateData extends ServicesListState {
  ServicesListStateData(this.services);

  final List<Service> services;
}

class ServicesListStateProcessing extends ServicesListState {}

class ServicesListStateError extends ServicesListState {
  ServicesListStateError(this.error);

  final dynamic error;
}
