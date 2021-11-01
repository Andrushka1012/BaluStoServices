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
  Widget _getChipRow(BuildContext context) => SingleChildScrollView(
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
                  label: Text(
                    'Выбрать',
                    style: AppTextStyles.bodyText1w500,
                  ),
                  backgroundColor: AppColors.primary,
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
                  backgroundColor: AppColors.secondary,
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
                  backgroundColor: AppColors.secondary,
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
                  backgroundColor: AppColors.secondary,
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
                  backgroundColor: AppColors.secondary,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _getContent(BuildContext context, StatisticStateDefault state) => ListView(
        children: [
          _getChipRow(context),
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
          if (state.matchingStatistic.isNotEmpty) ...state.matchingStatistic.map((e) => UserStatisticItem(e)).toList()
        ],
      );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StatisticBloc, StatisticState>(
        listener: _handleEvents,
        buildWhen: (_, current) => current is StatisticStateDefault || current is StatisticStateProcessing,
        builder: (context, StatisticState state) {
          return ProgressContainer(
            isProcessing: state is StatisticStateProcessing,
            child: state is StatisticStateDefault ? _getContent(context, state) : Container(),
          );
        });
  }

  void _handleEvents(BuildContext context, StatisticState state) {
    if (state is StatisticStateError) {
      showErrorDialog(context, state.error);
    }
  }

  String _getMessage(StatisticStateDefault state) {
    if (state.startDate == null && state.endDate == null) return 'Статистика за все время';
    final buffer = StringBuffer('Статистика за период');

    if (state.startDate != null) buffer.write(' от ${state.startDate!.formattedDay()}');
    if (state.endDate != null) buffer.write(' до ${state.endDate!.formattedDay()}');

    return buffer.toString();
  }
}
