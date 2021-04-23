import 'package:intl/intl.dart';

class Format {
  ///The result is time in format HH:MM
  static String getClockTime(DateTime date) {
    return DateFormat.jm().format(date);
  }
}
