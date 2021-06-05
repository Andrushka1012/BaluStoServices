import 'package:balu_sto/features/firestore/models/service.dart';
import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:balu_sto/helpers/styles/text_styles.dart';
import 'package:balu_sto/screens/shared/home/recentServces/bloc/recent_services_bloc.dart';
import 'package:balu_sto/widgets/app_card.dart';
import 'package:balu_sto/widgets/pages/koin_page.dart';
import 'package:balu_sto/widgets/service_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecentServicesForm extends KoinPage<RecentServicesBloc> {
  RecentServicesForm({required this.onServiceSelected, required this.onShowAll});

  final Function(Service) onServiceSelected;
  final Function() onShowAll;

  @override
  void initBloc(RecentServicesBloc bloc) {
    bloc.add(RecentServicesEvent.INIT);
  }

  Widget _getRecentServicesItem(BuildContext context, RecentServicesStateDataReady state) => AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: Dimens.spanBig,
                bottom: Dimens.spanSmall,
              ),
              child: Text('Последние услуги', style: AppTextStyles.headline2Yanone,),
            ),
            ...state.services.map(
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
    return BlocBuilder<RecentServicesBloc, RecentServicesState>(
      builder: (_, RecentServicesState state) => state is RecentServicesStateDataReady && state.services.isNotEmpty
          ? _getRecentServicesItem(context, state)
          : Container(),
    );
  }
}
