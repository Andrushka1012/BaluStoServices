import 'package:balu_sto/features/firestore/models/transaction.dart';
import 'package:balu_sto/helpers/extensions/date_extensions.dart';
import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:balu_sto/helpers/styles/text_styles.dart';
import 'package:balu_sto/infrastructure/auth/user_identity.dart';
import 'package:balu_sto/screens/shared/home/transactionDetails/view/transaction_details_page.dart';
import 'package:flutter/material.dart';
import 'package:koin_flutter/koin_flutter.dart';

class TransactionItem extends StatelessWidget {
  TransactionItem(this.transaction);

  final WorkTransaction transaction;
  late final UserIdentity _userIdentity = get();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        TransactionDetailsPage.PAGE_NAME,
        arguments: TransactionDetailsPageArgs(transaction),
      ),
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
                      'включает услуг ${transaction.servicesCount}' +
                          (_userIdentity.isAdmin ? 'для ${transaction.members.length} работников' : ''),
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
