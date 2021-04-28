class DateChecker {
  static bool checkIfSameDay(DateTime dateTime) {
    final dayBegin = DateTime.now().subtract(Duration(
      hours: DateTime.now().hour,
      minutes: DateTime.now().minute,
      seconds: DateTime.now().second,
    ));
    if (dateTime.difference(dayBegin).isNegative) return false;
    if (dateTime.difference(dayBegin).inHours <= 24) return true;
    return false;
  }

  static bool checkIfSameWeek(DateTime dateTime) {
    final weekBegin = DateTime.now().subtract(Duration(
      days: DateTime.now().weekday,
      hours: DateTime.now().hour,
      minutes: DateTime.now().minute,
      seconds: DateTime.now().second,
    ));
    if (dateTime.difference(weekBegin).isNegative) return false;
    if (dateTime.difference(weekBegin).inDays <= 7) return true;
    return false;
  }

  static bool checkIfSameMonth(DateTime dateTime) {
    final monthBegin = DateTime.now().subtract(Duration(
      days: DateTime.now().day,
      hours: DateTime.now().hour,
      minutes: DateTime.now().minute,
      seconds: DateTime.now().second,
    ));
    if (dateTime.difference(monthBegin).isNegative) return false;
    if (dateTime.difference(monthBegin).inDays <= 30) return true;
    return false;
  }

  static bool checkIfSameYear(DateTime dateTime) {
    if (dateTime.year == DateTime.now().year) return true;
    return false;
  }
}
