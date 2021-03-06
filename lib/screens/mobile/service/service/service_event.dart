part of 'service_bloc.dart';

@immutable
abstract class ServiceEvent {}

class ServiceEventInit extends ServiceEvent {}

class ServiceEventNameChanged extends ServiceEvent {
  ServiceEventNameChanged(this.value);

  final String value;
}

class ServiceEventMoneyAmountChanged extends ServiceEvent {
  ServiceEventMoneyAmountChanged(this.value);

  final String value;
}

class ServiceEventApply extends ServiceEvent {}

class ServiceEventTakePhoto extends ServiceEvent {}

class ServiceEventRemovePhoto extends ServiceEvent {}

class ServiceEventDelete extends ServiceEvent {}

class ServiceEventPrefill extends ServiceEvent {

  ServiceEventPrefill(this.popularService);

  final PopularService popularService;
}
