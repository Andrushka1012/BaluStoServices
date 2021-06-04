part of 'service_bloc.dart';

@immutable
abstract class ServiceEvent {}

class ServiceEventNameChanged extends ServiceEvent{
  ServiceEventNameChanged(this.value);
  final String value;
}
class ServiceEventMoneyAmountChanged extends ServiceEvent{
  ServiceEventMoneyAmountChanged(this.value);
  final String value;
}

class ServiceEventApply extends ServiceEvent{}
class ServiceEventTakePhoto extends ServiceEvent{}
class ServiceEventRemovePhoto extends ServiceEvent{}
