import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:balu_sto/helpers/styles/text_styles.dart';
import 'package:flutter/material.dart';

ThemeData createTheme(BuildContext context) => ThemeData(
      primaryColor: AppColors.primary,
      accentColor: AppColors.secondary,
      backgroundColor: AppColors.white,
      scaffoldBackgroundColor: AppColors.white,
      errorColor: AppColors.redTart,
      cardColor: AppColors.white,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.secondary,
      ),
      inputDecorationTheme: _inputDecorationTheme(),
    );

InputDecorationTheme _inputDecorationTheme() => InputDecorationTheme(
      alignLabelWithHint: true,
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.secondary, width: 2)),
      focusColor: AppColors.secondary,
      contentPadding: EdgeInsets.only(bottom: 8),
      labelStyle: AppTextStyles.bodyText2.copyWith(height: 1, color: AppColors.secondaryDark),
      hintStyle: AppTextStyles.bodyText1.copyWith(height: 1),
      errorStyle: AppTextStyles.caption.copyWith(color: AppColors.redTart),
    );
