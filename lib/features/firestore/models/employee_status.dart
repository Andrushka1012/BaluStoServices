import 'package:balu_sto/features/firestore/models/service.dart';
import 'package:balu_sto/features/firestore/models/service_status.dart';
import 'package:balu_sto/features/firestore/models/user.dart';

class EmployeeStatusModel {
  EmployeeStatusModel({
    required this.user,
    required this.services,
  });

  final AppUser user;
  final List<Service> services;

  List<Service> get toConfirmation =>
      services.where((service) => service.status == ServiceStatus.NOT_CONFIRMED).toList();

  List<Service> get toPayment => services.where((service) => service.status == ServiceStatus.CONFIRMED).toList();
}
