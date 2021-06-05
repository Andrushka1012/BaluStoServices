part of 'service_bloc.dart';

abstract class ServiceState {}

class DefaultServiceState extends ServiceState {
  DefaultServiceState._(
      {required this.serviceId,
      required this.service,
      required this.isEditMode,
      required this.serviceName,
      required this.moneyAmount,
      this.photo});

  final String serviceId;
  final Service? service;
  final bool isEditMode;
  final String serviceName;
  final String moneyAmount;
  File? photo;

  static DefaultServiceState create(Service? service, bool isEditMode) => DefaultServiceState._(
        serviceId: service?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        service: service,
        isEditMode: isEditMode,
        moneyAmount: service?.moneyAmount.toString() ?? '',
        serviceName: service?.serviceName ?? '',
      );

  DefaultServiceState copyWith({
    String? serviceName,
    String? moneyAmount,
    File? photo,
  }) =>
      DefaultServiceState._(
          serviceId: this.serviceId,
          service: service,
          isEditMode: this.isEditMode,
          serviceName: serviceName ?? this.serviceName,
          moneyAmount: moneyAmount ?? this.moneyAmount,
          photo: photo ?? this.photo);
}

class ServiceStateProcessing extends ServiceState {}

class ServiceStateSuccess extends ServiceState {}

class ServiceStateError extends ServiceState {
  ServiceStateError(this.error, this.close);

  final dynamic error;
  final bool close;
}
