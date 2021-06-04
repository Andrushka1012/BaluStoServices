import 'package:balu_sto/features/firestore/models/service.dart';
import 'package:balu_sto/screens/mobile/service/view/service_page.dart';
import 'package:balu_sto/screens/shared/recentServces/bloc/recent_services_bloc.dart';
import 'package:balu_sto/widgets/pages/koin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecentServicesForm extends KoinPage<RecentServicesBloc> {

  RecentServicesForm({required this.onServiceSelected});

  final Function(Service) onServiceSelected;

  @override
  void initBloc(RecentServicesBloc bloc) {
    bloc.add(RecentServicesEvent.INIT);
  }

  Widget _getRecentServicesItem(BuildContext context, RecentServicesStateDataReady state) => Column(
        children: [
          ...state.services.map(
            (service) => _getServiceItem(context, service),
          )
        ],
      );

  Widget _getServiceItem(BuildContext context, Service service) => GestureDetector(
        onTap: () => onServiceSelected(service),
        child: Column(
          children: [
            if (service.photoUrl != null)
              SizedBox(
                width: 50,
                height: 50,
                child: Image.network(service.photoUrl!),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('${service.serviceName} : ${service.moneyAmount} - ${service.localData?.isUploaded}'),
            ),
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
