part of 'user_services_bloc.dart';

@immutable
abstract class UserServicesState {}

class InitialRecentServicesState extends UserServicesState {}

class UserServicesStateDataReady extends UserServicesState {
  UserServicesStateDataReady(
    this.services,
    this.user,
  );

  final List<Service> services;
  final AppUser user;

  int get toConfirmationAmount => services
      .where((element) => element.status == ServiceStatus.NOT_CONFIRMED)
      .fold(0, (int previousValue, element) => previousValue + element.moneyAmount);

  int get toPaymentAmount => services
      .where((element) => element.status == ServiceStatus.CONFIRMED)
      .fold(0, (int previousValue, element) => previousValue + element.moneyAmount);
}
