part of 'recent_services_bloc.dart';

@immutable
abstract class RecentServicesState {}

class InitialRecentServicesState extends RecentServicesState {}

class RecentServicesStateDataReady extends RecentServicesState {
  RecentServicesStateDataReady(this.services);

  final List<Service> services;
}
