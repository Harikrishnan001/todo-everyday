import 'package:intl/intl.dart';

class Format {
  ///The result is time in format HH:MM
  static String getClockTime(DateTime date) {
    return DateFormat.jm().format(date);
  }

  static String getDate(DateTime date) {
    return DateFormat('d ${getMonthName(date)} y ', 'en_US').format(date);
  }

  static String getTime(DateTime date) {
    return DateFormat('hh:mma').format(date);
  }

  static String getCalendarDate(DateTime date) {
    final String month = getMonthName(date);
    return DateFormat('E d').format(date) + " " + month;
  }

  static String getMonthDayMonthName(DateTime date) {
    return DateFormat('d ${getMonthName(date)}').format(date);
  }

  static String getMonthName(DateTime date) {
    String month;
    switch (date.month) {
      case 1:
        month = 'January';
        break;
      case 2:
        month = 'February';
        break;
      case 3:
        month = 'March';
        break;
      case 4:
        month = 'April';
        break;
      case 5:
        month = 'May';
        break;
      case 6:
        month = 'June';
        break;
      case 7:
        month = 'July';
        break;
      case 8:
        month = 'August';
        break;
      case 9:
        month = 'September';
        break;
      case 10:
        month = 'October';
        break;
      case 11:
        month = 'November';
        break;
      case 12:
        month = 'December';
        break;
    }
    return month;
  }
}
