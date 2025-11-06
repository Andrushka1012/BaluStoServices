import 'package:balu_sto/helpers/dialogs.dart';
import 'package:balu_sto/helpers/extensions/date_extensions.dart';
import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:balu_sto/helpers/styles/text_styles.dart';
import 'package:balu_sto/screens/shared/home/statistic/bloc/statistic_bloc.dart';
import 'package:balu_sto/screens/shared/home/statistic/view/widgets/user_statistic_item.dart';
import 'package:balu_sto/widgets/containers/progress_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticForm extends StatelessWidget {
  Widget _getChipRow(BuildContext context, StatisticStateDefault state) =>
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.spanTiny),
              child: GestureDetector(
                onTap: () async {
                  final range = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime.now().subtract(Duration(days: 365)),
                    lastDate: DateTime.now(),
                    cancelText: 'Закрыть',
                    helpText: '',
                    saveText: "Выбрать",
                  );
                  if (range != null) {
                    context.read<StatisticBloc>().filterByRange(range);
                  }
                },
                child: Chip(
                  avatar: Icon(
                    Icons.calendar_today,
                    color: AppColors.white,
                    size: 16,
                  ),
                  label: Text(
                    'Выбрать период',
                    style: AppTextStyles.bodyText1w500,
                  ),
                  backgroundColor: Color.fromRGBO(76, 175, 80, 1),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.spanTiny),
              child: GestureDetector(
                onTap: () => context.read<StatisticBloc>().filterByAllTime(),
                child: Chip(
                  label: Text(
                    'Все время',
                    style: AppTextStyles.bodyText1w500,
                  ),
                  backgroundColor: _isAllTimeSelected(state)
                      ? AppColors.primary
                      : AppColors.secondary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.spanTiny),
              child: GestureDetector(
                onTap: () => context.read<StatisticBloc>().filterByThisMonth(),
                child: Chip(
                  label: Text(
                    'В этом месяце',
                    style: AppTextStyles.bodyText1w500,
                  ),
                  backgroundColor: _isThisMonthSelected(state)
                      ? AppColors.primary
                      : AppColors.secondary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.spanTiny),
              child: GestureDetector(
                onTap: () => context.read<StatisticBloc>().filterByLastMonth(),
                child: Chip(
                  label: Text(
                    'Предыдущий месяц',
                    style: AppTextStyles.bodyText1w500,
                  ),
                  backgroundColor: _isLastMonthSelected(state)
                      ? AppColors.primary
                      : AppColors.secondary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.spanTiny),
              child: GestureDetector(
                onTap: () => context.read<StatisticBloc>().filterBy3Month(),
                child: Chip(
                  label: Text(
                    '3 месяца',
                    style: AppTextStyles.bodyText1w500,
                  ),
                  backgroundColor: _is3MonthSelected(state)
                      ? AppColors.primary
                      : AppColors.secondary,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _getContent(BuildContext context, StatisticStateDefault state) =>
      ListView(
        children: [
          _getChipRow(context, state),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.spanBig,
              vertical: Dimens.spanSmall,
            ),
            child: Center(
              child: Text(
                _getMessage(state),
                style: AppTextStyles.bodyText2w500.copyWith(
                  fontSize: Dimens.fontSizeHeadline2,
                ),
              ),
            ),
          ),
          if (state.matchingStatistic.isNotEmpty)
            ...state.matchingStatistic.map((e) => UserStatisticItem(e)).toList()
        ],
      );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StatisticBloc, StatisticState>(
        listener: _handleEvents,
        buildWhen: (_, current) =>
            current is StatisticStateDefault ||
            current is StatisticStateProcessing,
        builder: (context, StatisticState state) {
          return ProgressContainer(
            isProcessing: state is StatisticStateProcessing,
            child: state is StatisticStateDefault
                ? _getContent(context, state)
                : Container(),
          );
        });
  }

  void _handleEvents(BuildContext context, StatisticState state) {
    if (state is StatisticStateError) {
      showErrorDialog(context, state.error);
    }
  }

  String _getMessage(StatisticStateDefault state) {
    if (state.startDate == null && state.endDate == null)
      return 'Статистика за все время';
    final buffer = StringBuffer('Статистика за период');

    if (state.startDate != null)
      buffer.write(' от ${state.startDate!.formattedDay()}');
    if (state.endDate != null)
      buffer.write(' до ${state.endDate!.formattedDay()}');

    return buffer.toString();
  }

  bool _isAllTimeSelected(StatisticStateDefault state) {
    return state.startDate == null && state.endDate == null;
  }

  bool _isThisMonthSelected(StatisticStateDefault state) {
    if (state.startDate == null || state.endDate == null) return false;
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    return state.startDate!.year == startOfMonth.year &&
        state.startDate!.month == startOfMonth.month &&
        state.startDate!.day == startOfMonth.day;
  }

  bool _isLastMonthSelected(StatisticStateDefault state) {
    if (state.startDate == null || state.endDate == null) return false;
    final now = DateTime.now();
    final startOfThisMonth = DateTime(now.year, now.month, 1);
    final lastMonth = startOfThisMonth.subtract(Duration(days: 1));
    final startOfLastMonth = DateTime(lastMonth.year, lastMonth.month, 1);

    return state.startDate!.year == startOfLastMonth.year &&
        state.startDate!.month == startOfLastMonth.month &&
        state.startDate!.day == startOfLastMonth.day;
  }

  bool _is3MonthSelected(StatisticStateDefault state) {
    if (state.startDate == null || state.endDate == null) return false;
    final now = DateTime.now();
    final threeMonthsAgo = now.subtract(Duration(days: 90));
    final startOf3Months =
        DateTime(threeMonthsAgo.year, threeMonthsAgo.month, 1);

    return state.startDate!.year == startOf3Months.year &&
        state.startDate!.month == startOf3Months.month &&
        state.startDate!.day == startOf3Months.day;
  }

  bool _isCustomRangeSelected(StatisticStateDefault state) {
    return state.startDate != null &&
        state.endDate != null &&
        !_isThisMonthSelected(state) &&
        !_isLastMonthSelected(state) &&
        !_is3MonthSelected(state);
  }
}
