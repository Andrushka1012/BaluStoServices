part of 'service_bloc.dart';

@immutable
abstract class ServiceState {}

class DefaultServiceState extends ServiceState {
  DefaultServiceState._({
    required this.service,
    required this.isEditMode,
    required this.serviceName,
    required this.moneyAmount,
  });

  static DefaultServiceState create(Service? service, bool isEditMode) => DefaultServiceState._(
        service: service,
        isEditMode: isEditMode,
        moneyAmount: service?.moneyAmount.toString() ?? '',
        serviceName: service?.serviceName ?? '',
      );

  DefaultServiceState copyWith({
    String? serviceName,
    String? moneyAmount,
  }) =>
      DefaultServiceState._(
        service: service,
        isEditMode: this.isEditMode,
        serviceName: serviceName ?? this.serviceName,
        moneyAmount: moneyAmount ?? this.moneyAmount,
      );

  final Service? service;
  final bool isEditMode;
  final String serviceName;
  final String moneyAmount;

}

class ServiceStateProcessing extends ServiceState {}

class ServiceStateSuccess extends ServiceState {}

class ServiceStateError extends ServiceState {
  ServiceStateError(this.error);

  final dynamic error;
}
