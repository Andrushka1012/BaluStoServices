import 'package:balu_sto/features/firestore/firestore_repository.dart';
import 'package:balu_sto/features/firestore/models/employee_status.dart';
import 'package:balu_sto/features/firestore/models/service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/src/material/date.dart';
import 'package:meta/meta.dart';

part 'statistic_state.dart';

class StatisticBloc extends Cubit<StatisticState> {
  StatisticBloc(this.selectedUserId, this._firestoreRepository) : super(StatisticStateProcessing());

  final String? selectedUserId;
  final FirestoreRepository _firestoreRepository;

  Future init() async {
    try {
      final response = await _firestoreRepository.getEmployees();
      response.throwIfNotSuccessful();

      final List<EmployeeStatusModel> selectedUsersStatistic = selectedUserId != null
          ? response.requiredData.where((element) => element.user.userId == selectedUserId).toList()
          : response.requiredData;

      emit(StatisticStateDefault(statistic: selectedUsersStatistic));
    } catch (e) {
      emit(StatisticStateError(e));
    }
  }

  void filterByThisMonth() {
    final previousState = state;
    if (previousState is! StatisticStateDefault) return;
    final DateTime now = DateTime.now();

    emit(
      StatisticStateDefault(
        statistic: previousState.statistic,
        startDate: DateTime(now.year, now.month, 1),
        endDate: now,
      ),
    );
  }

  void filterByLastMonth() {
    final previousState = state;
    if (previousState is! StatisticStateDefault) return;
    final DateTime now = DateTime.now();

    final startOfMonth = DateTime(now.year, now.month, 1);
    final subtracted = startOfMonth.subtract(Duration(days: 1));

    emit(
      StatisticStateDefault(
        statistic: previousState.statistic,
        startDate: DateTime(subtracted.year, subtracted.month, 1),
        endDate: subtracted,
      ),
    );
  }

  void filterBy3Month() {
    final previousState = state;
    if (previousState is! StatisticStateDefault) return;
    final DateTime now = DateTime.now();
    final subtracted = now.subtract(Duration(days: 90));
    
    emit(
      StatisticStateDefault(
        statistic: previousState.statistic,
        startDate: DateTime(subtracted.year, subtracted.month, 1),
        endDate: now,
      ),
    );
  }

  void filterByAllTime() {
    final previousState = state;
    if (previousState is! StatisticStateDefault) return;
    emit(
      StatisticStateDefault(
        statistic: previousState.statistic,
        startDate: null,
        endDate: null,
      ),
    );
  }

  void filterByRange(DateTimeRange range) {
    final previousState = state;
    if (previousState is! StatisticStateDefault) return;
    emit(
      StatisticStateDefault(
        statistic: previousState.statistic,
        startDate: range.start,
        endDate: range.end,
      ),
    );
  }
}
