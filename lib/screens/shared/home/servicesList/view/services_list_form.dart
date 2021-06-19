import 'package:balu_sto/features/firestore/models/service.dart';
import 'package:balu_sto/features/firestore/models/service_status.dart';
import 'package:balu_sto/helpers/dialogs.dart';
import 'package:balu_sto/infrastructure/auth/user_identity.dart';
import 'package:balu_sto/screens/mobile/service/view/service_page.dart';
import 'package:balu_sto/screens/shared/home/serviceDetails/view/service_details_page.dart';
import 'package:balu_sto/screens/shared/home/servicesList/bloc/services_list_bloc.dart';
import 'package:balu_sto/widgets/containers/progress_container.dart';
import 'package:balu_sto/widgets/pages/koin_with_params_page.dart';
import 'package:balu_sto/widgets/service_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin_flutter/koin_flutter.dart';

class ServicesListForm extends KoinWithParamsPage<ServicesListBloc, String> {
  ServicesListForm(this.userId);

  final String userId;

  late final UserIdentity _userIdentity = get();

  @override
  String get params => userId;

  @override
  void initBloc(ServicesListBloc bloc) {
    bloc.add(ServicesListEvent.INIT);
  }

  Widget _getContentItem(BuildContext context, List<Service> services) => ListView(
        children: services
            .map(
              (service) => ServiceItem(
                service,
                onSelected:
                    _userIdentity.requiredCurrentUser.userId == userId && service.status == ServiceStatus.NOT_CONFIRMED
                        ? (service) => Navigator.of(context).pushNamed(
                              ServicePage.PAGE_NAME,
                              arguments: ServicePageArgs(
                                editMode: true,
                                service: service,
                              ),
                            )
                        : (service) => Navigator.of(context).pushNamed(
                              ServiceDetailsPage.getPageName(userId, service.id),
                              arguments: ServiceDetailsPageArgs(
                                service,
                              ),
                            ),
              ),
            )
            .toList(),
      );

  @override
  Widget buildPage(BuildContext context) => BlocConsumer<ServicesListBloc, ServicesListState>(
        listener: _handleEvents,
        builder: (_, ServicesListState state) => ProgressContainer(
          isProcessing: state is ServicesListStateProcessing,
          child: state is ServicesListStateData ? _getContentItem(context, state.services) : Container(),
        ),
      );

  void _handleEvents(BuildContext context, ServicesListState state) {
    if (state is ServicesListStateError) {
      showErrorDialog(context, state.error);
    }
  }
}
