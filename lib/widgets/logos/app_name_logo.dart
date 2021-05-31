import 'dart:ui';

import 'package:balu_sto/helpers/styles/dimens.dart';
import 'package:balu_sto/helpers/styles/text_styles.dart';
import 'package:flutter/material.dart';

class AppNameLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(Dimens.spanMicro),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.spanSmall,
              vertical: Dimens.spanTiny,
            ),
            child: Column(
              children: [
                Text(
                  'Балу',
                  style: AppTextStyles.bodyText1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('СТО Services', style: AppTextStyles.bodyText1.copyWith(color: Colors.white))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
