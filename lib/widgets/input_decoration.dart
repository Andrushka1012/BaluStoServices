import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:balu_sto/helpers/styles/text_styles.dart';
import 'package:flutter/material.dart';

InputDecoration getDecoration({String? errorText}) => InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.all(Dimens.spanSmall),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(Dimens.spanTiny)),
        borderSide: BorderSide(width: 1, color: AppColors.secondaryDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(Dimens.spanTiny)),
        borderSide: BorderSide(width: 1, color: Colors.grey[300]!),
      ),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(Dimens.spanTiny)),
          borderSide: BorderSide(
            width: 1,
          )),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(Dimens.spanTiny)),
          borderSide: BorderSide(width: 1, color: AppColors.redTart)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(Dimens.spanTiny)),
          borderSide: BorderSide(width: 1, color: AppColors.redTart)),
      hintStyle: AppTextStyles.bodyText1.copyWith(color: Colors.grey[500]!),
      errorText: errorText,
    );
