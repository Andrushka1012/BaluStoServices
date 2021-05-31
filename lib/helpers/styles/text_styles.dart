import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dimens.dart';

class AppTextStyles {
  // Core styles
  static TextStyle get headline0 => GoogleFonts.dmSans(
      fontSize: Dimens.fontSizeHeadline0, fontWeight: FontWeight.w500, height: 1.25, letterSpacing: 0.36);

  static TextStyle get headline1 => GoogleFonts.dmSans(
      fontSize: Dimens.fontSizeHeadline1, fontWeight: FontWeight.w500, height: 1.2, letterSpacing: 0.1);

  static TextStyle get headline2 => GoogleFonts.dmSans(
      fontSize: Dimens.fontSizeHeadline2, fontWeight: FontWeight.w500, height: 1.2, letterSpacing: 0.1);

  static TextStyle get headline3 => GoogleFonts.dmSans(
      fontSize: Dimens.fontSizeHeadline3, fontWeight: FontWeight.w500, height: 1.4, letterSpacing: 0.1);

  static TextStyle get headline4 => GoogleFonts.dmSans(
      fontSize: Dimens.fontSizeHeadline4, fontWeight: FontWeight.w500, height: 1.3, letterSpacing: 0.1);

  static TextStyle get overline => GoogleFonts.dmSans(
      fontSize: Dimens.fontSizeOverline, fontWeight: FontWeight.w400, height: 1.2, letterSpacing: 0.1);

  static TextStyle get bodyText1 => GoogleFonts.dmSans(
      fontSize: Dimens.fontSizeBodyText1, fontWeight: FontWeight.w400, height: 1.5, letterSpacing: 0);

  static TextStyle get bodyText1w500 => GoogleFonts.dmSans(
      fontSize: Dimens.fontSizeBodyText1, fontWeight: FontWeight.w500, height: 1.5, letterSpacing: 0);

  static TextStyle get bodyText2 => GoogleFonts.dmSans(
      fontSize: Dimens.fontSizeBodyText2, fontWeight: FontWeight.normal, height: 1.4, letterSpacing: 0);

  static TextStyle get bodyText2w500 => GoogleFonts.dmSans(
      fontSize: Dimens.fontSizeBodyText2, fontWeight: FontWeight.w500, height: 1.4, letterSpacing: 0);

  static TextStyle get caption => GoogleFonts.dmSans(
      fontSize: Dimens.fontSizeCaption, fontWeight: FontWeight.normal, height: 1.3, letterSpacing: 0);
}
