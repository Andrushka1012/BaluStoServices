enum ServiceStatus { NOT_CONFIRMED, CONFIRMED, PAYED }

extension ServiceStatusExtenion on ServiceStatus {
  String get value {
    switch (this) {
      case ServiceStatus.NOT_CONFIRMED:
        return 'NOT_CONFIRMED';
      case ServiceStatus.CONFIRMED:
        return 'CONFIRMED';
      case ServiceStatus.PAYED:
        return 'PAYED';
    }
  }

  static ServiceStatus create(String? value) {
    switch (value) {
      case 'NOT_CONFIRMED':
        return ServiceStatus.NOT_CONFIRMED;
      case 'CONFIRMED':
        return ServiceStatus.CONFIRMED;
      case 'PAYED':
        return ServiceStatus.PAYED;
      default:
        return ServiceStatus.NOT_CONFIRMED;
    }
  }
}
