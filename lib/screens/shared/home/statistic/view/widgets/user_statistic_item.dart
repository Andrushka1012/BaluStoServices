import 'package:balu_sto/features/firestore/models/employee_status.dart';
import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:balu_sto/helpers/styles/text_styles.dart';
import 'package:balu_sto/widgets/app_card.dart';
import 'package:flutter/material.dart';
import 'package:balu_sto/helpers/extensions/number_extension.dart';

class UserStatisticItem extends StatelessWidget {
  UserStatisticItem(this.status);

  final EmployeeStatusModel status;

  @override
  Widget build(BuildContext context) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                status.user.name,
                style: AppTextStyles.headline2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _getStatisticRow('Количество услуг', status.payed.length.toString()),
            _getStatisticRow('Прийнято', status.obtainedAmount.formatThousands()),
            _getStatisticRow('Оплаченно', status.payedAmount.formatThousands()),
          ],
        ),
      );

  Widget _getStatisticRow(String title, String value) => Row(
        children: [
          Text(
            '$title:',
            style: AppTextStyles.headline1,
          ),
          SizedBox(
            width: Dimens.spanSmall,
          ),
          Text(
            value,
            style: AppTextStyles.headline1,
          ),
        ],
      );
}
