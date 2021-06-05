import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formatted() => DateFormat('dd.MM.yyyy – HH:mm').format(this);
}
