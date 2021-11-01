import 'dart:math';

import 'package:intl/intl.dart';

extension NumberExtension on num {
  String formatThousands({int fractionDigits = 1}) {
    if (this == 0.0) return '0';

    final double fractionDouble = double.parse(toDouble().toStringAsFixed(fractionDigits));

    final NumberFormat numberFormat = NumberFormat.decimalPattern('en');
    numberFormat.minimumFractionDigits = fractionDigits;
    numberFormat.maximumFractionDigits = fractionDigits;
    return numberFormat.format(fractionDouble);
  }

  num toRadians() => this / 180.0 * pi;
}
