import 'package:balu_sto/features/firestore/models/service.dart';
import 'package:balu_sto/helpers/extensions/list_extensions.dart';
import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:balu_sto/helpers/styles/text_styles.dart';
import 'package:balu_sto/screens/shared/home/userServices/bloc/user_services_bloc.dart';
import 'package:balu_sto/widgets/app_card.dart';
import 'package:balu_sto/widgets/pages/koin_with_params_page.dart';
import 'package:balu_sto/widgets/service_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserServicesForm extends KoinWithParamsPage<RecentServicesBloc, String> {
  UserServicesForm({required this.userId, required this.onServiceSelected, required this.onShowAll});

  final String userId;
  final Function(Service) onServiceSelected;
  final Function() onShowAll;

  @override
  String get params => userId;

  @override
  void initBloc(RecentServicesBloc bloc) {
    bloc.add(UserServicesEvent.INIT);
  }

  Widget _getServicesStatisticItem(BuildContext context, UserServicesStateDataReady state) => AppCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Text(
                  'Сума к потверждению:  ',
                  style: AppTextStyles.bodyText1.copyWith(color: AppColors.gray),
                ),
                Text(
                  '${state.toConfirmationAmount}',
                  style: AppTextStyles.headline3,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Сума к оплате:  ',
                  style: AppTextStyles.bodyText1.copyWith(color: AppColors.gray),
                ),
                Text(
                  '${state.toPaymentAmount / 2}',
                  style: AppTextStyles.headline3,
                ),
                Text(
                  '(${state.toPaymentAmount})',
                  style: AppTextStyles.bodyText1.copyWith(color: AppColors.gray),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _getRecentServicesItem(BuildContext context, UserServicesStateDataReady state) => AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: Dimens.spanBig,
                bottom: Dimens.spanSmall,
              ),
              child: Text(
                'Последние услуги',
                style: AppTextStyles.headline2Yanone,
              ),
            ),
            ...state.services.innerList(0, 4).map(
                  (service) => ServiceItem(
                    service,
                    onSelected: onServiceSelected,
                  ),
                ),
            Padding(
              padding: const EdgeInsets.only(
                top: Dimens.spanTiny,
                bottom: Dimens.spanMediumLarge,
              ),
              child: GestureDetector(
                onTap: onShowAll,
                child: Text(
                  'Посмотреть все',
                  style: AppTextStyles.bodyText1.copyWith(color: AppColors.primary),
                ),
              ),
            )
          ],
        ),
      );

  @override
  Widget buildPage(BuildContext context) {
    return BlocBuilder<RecentServicesBloc, UserServicesState>(
      builder: (_, UserServicesState state) => state is UserServicesStateDataReady
          ? Column(
              children: [
                _getServicesStatisticItem(context, state),
                if (state.services.isNotEmpty) _getRecentServicesItem(context, state),
              ],
            )
          : Container(),
    );
  }
}
