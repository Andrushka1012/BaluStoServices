import 'package:balu_sto/helpers/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dimens.dart';

class AppTextStyles {
  // Core styles
  static TextStyle get headline0 => GoogleFonts.pattaya(
        fontSize: Dimens.fontSizeHeadline0,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.36,
        color: AppColors.white,
      );

  static TextStyle get headline1 => GoogleFonts.pattaya(
        fontSize: Dimens.fontSizeHeadline1,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: AppColors.white,
      );

  static TextStyle get headline2 => GoogleFonts.pattaya(
        fontSize: Dimens.fontSizeHeadline2,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: AppColors.white,
      );

  static TextStyle get headline2Yanone => GoogleFonts.yanoneKaffeesatz(
        fontSize: Dimens.fontSizeHeadline2,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: AppColors.white,
      );

  static TextStyle get headline3 => GoogleFonts.pattaya(
        fontSize: Dimens.fontSizeHeadline3,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: AppColors.white,
      );

  static TextStyle get headline4 => GoogleFonts.pattaya(
        fontSize: Dimens.fontSizeHeadline4,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: AppColors.white,
      );

  static TextStyle get overline => GoogleFonts.yanoneKaffeesatz(
        fontSize: Dimens.fontSizeOverline,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        color: AppColors.white,
      );

  static TextStyle get bodyText1 => GoogleFonts.yanoneKaffeesatz(
        fontSize: Dimens.fontSizeBodyText1,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: AppColors.white,
      );

  static TextStyle get bodyText1w500 => GoogleFonts.yanoneKaffeesatz(
        fontSize: Dimens.fontSizeBodyText1,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        color: AppColors.white,
      );

  static TextStyle get bodyText2 => GoogleFonts.yanoneKaffeesatz(
        fontSize: Dimens.fontSizeBodyText2,
        fontWeight: FontWeight.normal,
        letterSpacing: 0,
        color: AppColors.white,
      );

  static TextStyle get bodyText2w500 => GoogleFonts.yanoneKaffeesatz(
        fontSize: Dimens.fontSizeBodyText2,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        color: AppColors.white,
      );

  static TextStyle get caption => GoogleFonts.yanoneKaffeesatz(
        fontSize: Dimens.fontSizeCaption,
        fontWeight: FontWeight.normal,
        letterSpacing: 0,
        color: AppColors.white,
      );
}
