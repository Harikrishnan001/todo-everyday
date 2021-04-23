import 'package:flutter/material.dart';

class DateElement extends StatelessWidget {
  final String dayWeek;
  final String dayMonth;
  final bool isToday;

  const DateElement(this.dayWeek, this.dayMonth, {this.isToday, Key key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          dayWeek,
          style: TextStyle(
            color: Colors.white,
            fontSize: isToday != null && isToday ? 20.0 : 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6.0),
        isToday == null || !isToday
            ? Text(
                dayMonth,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              )
            : Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: Colors.orange[300],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  dayMonth,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15.0,
                  ),
                ),
              ),
      ],
    );
  }
}
