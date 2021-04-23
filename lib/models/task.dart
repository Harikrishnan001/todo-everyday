import 'package:flutter/foundation.dart';

class Task {
  int startTime;
  int endTime;
  String task;
  String taskDescription;
  bool isDone;

  Task({
    @required this.startTime,
    @required this.endTime,
    @required this.task,
    this.taskDescription,
    this.isDone = false,
  });
}
