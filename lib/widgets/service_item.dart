import 'package:balu_sto/features/firestore/models/service.dart';
import 'package:balu_sto/features/firestore/models/service_status.dart';
import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:balu_sto/helpers/styles/text_styles.dart';
import 'package:balu_sto/widgets/balu_image.dart';
import 'package:flutter/material.dart';

class ServiceItem extends StatelessWidget {
  const ServiceItem(this.service, {required this.onSelected, this.showArrow = true});

  final Service service;
  final Function(Service)? onSelected;
  final bool showArrow;

  Widget get _placeHolderIcon => Icon(
        Icons.car_repair,
        size: Dimens.spanHuge,
        color: AppColors.white,
      );

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onSelected != null ? () => onSelected?.call(service) : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.spanBig, vertical: Dimens.spanMedium),
          child: Row(
            children: [
              Container(
                width: Dimens.spanLarge,
                height: Dimens.spanLarge,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.all(
                    Radius.circular(100),
                  ),
                ),
                child: Center(
                  child: service.hasPhoto
                      ? BaluImage(
                          imageUrl: service.photoUrl!,
                          placeholder: _placeHolderIcon,
                        )
                      : _placeHolderIcon,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: Dimens.spanMedium, right: Dimens.spanHuge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${service.serviceName} - ${service.moneyAmount} грн',
                        style: AppTextStyles.bodyText1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${service.formattedDate}, статус: ${service.status.translation}',
                        style: TextStyle(color: AppColors.gray, fontSize: Dimens.fontSizeCaption),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ),
              if (onSelected != null && showArrow)
                Icon(
                  Icons.chevron_right,
                  color: AppColors.white,
                  size: Dimens.spanMedium,
                ),
              SizedBox(
                width: Dimens.spanSmall,
              )
            ],
          ),
        ),
      );
}
