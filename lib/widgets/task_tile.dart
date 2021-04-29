import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo/data/sql_database.dart';
import '../screens/edit_reminder_screen.dart';
import '../helpers/date_time.dart';
import '../models/task.dart';

class TaskTile extends StatefulWidget {
  final Task task;
  final double width;
  final VoidCallback onUpdate;

  const TaskTile(
      {Key key,
      @required this.task,
      @required this.width,
      @required this.onUpdate})
      : super(key: key);

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  final _database = SQLDatabase();
  Timer _timer;
  Color _dotColor;
  void initState() {
    _calculateColor();
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      final oldColor = _dotColor;
      _calculateColor();
      if (oldColor != _dotColor) {
        setState(() {});
        if (_dotColor == Colors.red) _timer.cancel();
      }
    });
    super.initState();
  }

  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _calculateColor() {
    if (widget.task.endTime < DateTime.now().millisecondsSinceEpoch &&
        !widget.task.isDone)
      _dotColor = Colors.red;
    else {
      _dotColor = widget.task.isDone ? Colors.grey : Colors.blue[700];
    }
  }

  Future<void> _onChecked(bool value) async {
    setState(() {
      widget.task.isDone = value;
      widget.task.shouldRemind = value ? false : true;
    });
    widget.onUpdate();
    await _database.updateTask(widget.task);
  }

  Future<void> _deleteTask() async {
    await _database.removeTask(widget.task);
    widget.onUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 12.0),
            EndTime(endTime: widget.task.endTime),
            DotPath(color: _dotColor),
            TaskHolder(task: widget.task),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  children: [
                    Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: widget.task.isDone,
                      onChanged: _dotColor == Colors.blue[700]
                          ? (value) => _onChecked(value)
                          : null,
                    ),
                    _dotColor == Colors.blue[700]
                        ? TextButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true)
                                  .push(MaterialPageRoute(
                                      builder: (_) => EditReminderScreen(
                                            task: widget.task,
                                            editMode: false,
                                          )));
                            },
                            child: Text('Details'),
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 32.0,
                            ),
                            onPressed: () {
                              _deleteTask();
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EndTime extends StatelessWidget {
  final int endTime;

  const EndTime({Key key, this.endTime}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String text;
    final endDate = DateTime.fromMillisecondsSinceEpoch(endTime);
    if (endDate.year != DateTime.now().year) {
      text = Format.getDate(endDate) + Format.getTime(endDate);
    } else if (endDate.difference(DateTime.now()).compareTo(Duration(days: 1)) >
        0) {
      text =
          Format.getMonthDayMonthName(endDate) + "\n" + Format.getTime(endDate);
    } else {
      text = Format.getClockTime(DateTime.fromMillisecondsSinceEpoch(endTime));
    }
    return Column(
      children: [
        SizedBox(height: 18.0),
        SizedBox(
          width: 60.0,
          height: 50.0,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey,
            ),
            overflow: TextOverflow.clip,
          ),
        ),
        Expanded(child: SizedBox()),
      ],
    );
  }
}

class DotPath extends StatelessWidget {
  final Color color;
  const DotPath({Key key, @required this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.circle,
            color: color,
            size: 4.0,
          ),
          Icon(
            Icons.circle,
            color: color,
            size: 4.0,
          ),
          Icon(
            Icons.circle,
            color: color,
            size: 13.0,
          ),
          Icon(
            Icons.circle,
            color: color,
            size: 4.0,
          ),
          Icon(
            Icons.circle,
            color: color,
            size: 4.0,
          ),
          Icon(
            Icons.circle,
            color: color,
            size: 4.0,
          ),
          Icon(
            Icons.circle,
            color: color,
            size: 4.0,
          ),
          Icon(
            Icons.circle,
            color: color,
            size: 4.0,
          ),
          Icon(
            Icons.circle,
            color: color,
            size: 4.0,
          ),
        ],
      ),
    );
  }
}

class TaskHolder extends StatelessWidget {
  final Task task;

  const TaskHolder({Key key, @required this.task}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.0,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              task.task,
              maxLines: 2,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                decoration: task.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 3.0),
          Flexible(
            child: Text(
              task.taskDescription == null || task.taskDescription.length == 0
                  ? 'Started on: ${Format.getTime(DateTime.fromMillisecondsSinceEpoch(task.startTime))} ${Format.getCalendarDate(DateTime.fromMillisecondsSinceEpoch(task.startTime))} '
                  : task.taskDescription,
              style: TextStyle(fontSize: 12.0),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
