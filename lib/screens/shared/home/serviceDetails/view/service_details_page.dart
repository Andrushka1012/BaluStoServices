import 'package:balu_sto/features/firestore/models/service.dart';
import 'package:balu_sto/features/firestore/models/service_status.dart';
import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:balu_sto/helpers/styles/text_styles.dart';
import 'package:balu_sto/widgets/app_card.dart';
import 'package:balu_sto/widgets/balu_appbar.dart';
import 'package:balu_sto/widgets/balu_image.dart';
import 'package:balu_sto/widgets/containers/web_constraints_container.dart';
import 'package:flutter/material.dart';

class ServiceDetailsPage extends StatelessWidget {
  static const PAGE_NAME = 'ServiceDetailsPage';

  ServiceDetailsPage(this._args);

  final ServiceDetailsPageArgs _args;

  static getPageName(String userId, String serviceId) => 'user/$userId/$serviceId/$PAGE_NAME';

  Widget get _placeHolderIcon => Icon(
        Icons.car_repair,
        size: Dimens.spanHuge,
        color: AppColors.white,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BaluAppbar(
        title: _args.service.serviceName,
        showBack: true,
      ),
      body: WebConstraintsContainer(
        child: AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => _showPhoto(context),
                child: Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                    child: Center(
                      child: _args.service.hasPhoto
                          ? BaluImage(
                              imageUrl: _args.service.photoUrl!,
                              placeholder: _placeHolderIcon,
                            )
                          : _placeHolderIcon,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Dimens.spanMedium,
                ),
                child: Center(
                  child: Text(
                    _args.service.serviceName,
                    style: AppTextStyles.headline1,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimens.spanSmall),
                child: Text(
                  'Статус: ${_args.service.status.translation}',
                  style: AppTextStyles.bodyText1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'Стоимость: ${_args.service.moneyAmount}',
                style: AppTextStyles.bodyText1,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimens.spanSmall),
                child: Text(
                  'Добавленно: ${_args.service.formattedDate}',
                  style: AppTextStyles.bodyText1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (_args.service.modifiedDate != null)
                Text(
                  'Измененно: ${_args.service.formattedModifiedDate!}',
                  style: AppTextStyles.bodyText1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPhoto(BuildContext context) {
    if (_args.service.hasPhoto) {
      showDialog(
          context: context,
          builder: (_) => BaluImage(
                imageUrl: _args.service.photoUrl!,
                placeholder: _placeHolderIcon,
                shape: BoxShape.rectangle,
              ));
    }
  }
}

class ServiceDetailsPageArgs {
  ServiceDetailsPageArgs(this.service);

  final Service service;
}
