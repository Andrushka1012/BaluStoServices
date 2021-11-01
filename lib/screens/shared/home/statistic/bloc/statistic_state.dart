part of 'statistic_bloc.dart';

@immutable
abstract class StatisticState {}

class StatisticStateProcessing extends StatisticState {}

class StatisticStateDefault extends StatisticState {
  StatisticStateDefault({
    required this.statistic,
    this.startDate,
    this.endDate,
  });

  final List<EmployeeStatusModel> statistic;
  final DateTime? startDate;
  final DateTime? endDate;

  List<EmployeeStatusModel> get matchingStatistic {
    final matching = statistic.map((element) {
      final List<Service> matchingServices = element.services
          .where((element) => startDate != null ? element.date.isAfter(startDate!) : true)
          .where((element) => endDate != null ? element.date.isBefore(endDate!) : true)
          .toList();

      return EmployeeStatusModel(user: element.user, services: matchingServices);
    });

    return matching.where((element) => element.services.isNotEmpty).toList();
  }
}

class StatisticStateError extends StatisticState {
  StatisticStateError(this.error);

  final dynamic error;
}
