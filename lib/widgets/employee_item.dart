import 'package:balu_sto/features/firestore/models/employee_status.dart';
import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:balu_sto/helpers/styles/text_styles.dart';
import 'package:flutter/material.dart';

class EmployeeItem extends StatelessWidget {
  const EmployeeItem(this.employee, {this.onEmployeeSelected});

  final EmployeeStatusModel employee;
  final Function(EmployeeStatusModel)? onEmployeeSelected;

  Widget get _placeHolderIcon => Icon(
        Icons.person,
        size: Dimens.spanHuge,
        color: AppColors.white,
      );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onEmployeeSelected != null ? () => onEmployeeSelected!.call(employee) : null,
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
                child: _placeHolderIcon,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: Dimens.spanMedium, right: Dimens.spanHuge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.user.name,
                      style: AppTextStyles.bodyText1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'подтвердить: ${employee.toConfirmation.length}  оплатить: ${employee.toPayment.length}',
                      style: TextStyle(color: AppColors.gray, fontSize: Dimens.fontSizeCaption),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
