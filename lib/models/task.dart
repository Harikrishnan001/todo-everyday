import 'package:flutter/foundation.dart';

class Task {
  int id;
  int startTime;
  int endTime;
  String task;
  String taskDescription;
  bool isDone;
  bool shouldRemind;

  Task({
    @required this.startTime,
    @required this.endTime,
    @required this.task,
    this.taskDescription,
    this.isDone = false,
    this.shouldRemind = false,
  });

  Map<String, dynamic> toMap() {
    var map = {
      'id': id,
      'startTime': startTime,
      'endTime': endTime,
      'task': task,
      'description': taskDescription,
      'isDone': isDone ? 1 : 0,
      'shouldRemind': shouldRemind ? 1 : 0,
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }

  Task.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.startTime = map['startTime'];
    this.endTime = map['endTime'];
    this.task = map['task'];
    this.taskDescription = map['description'];
    this.isDone = map['isDone'] == 1 ? true : false;
    this.shouldRemind = map['shouldRemind'] == 1 ? true : false;
  }
}
