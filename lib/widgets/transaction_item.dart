import 'package:balu_sto/features/firestore/models/transaction.dart';
import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:balu_sto/helpers/styles/text_styles.dart';
import 'package:balu_sto/screens/shared/home/serviceModification/view/services_modification_page.dart';
import 'package:flutter/material.dart';
import 'package:balu_sto/helpers/extensions/date_extensions.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem(this.transaction);

  final WorkTransaction transaction;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.spanBig, vertical: Dimens.spanSmall),
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
                child: Icon(
                  transaction.status.icon,
                  color: AppColors.white,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: Dimens.spanMedium, right: Dimens.spanHuge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${transaction.status.translation} ${transaction.date.formatted()}',
                      style: AppTextStyles.bodyText1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'включает услуг ${transaction.servicesCount} для ${transaction.members.length} работников',
                      style: TextStyle(color: AppColors.gray, fontSize: Dimens.fontSizeCaption),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.white,
              size: Dimens.spanMedium,
            ),
          ],
        ),
      ),
    );
  }
}
