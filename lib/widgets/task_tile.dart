import 'package:flutter/material.dart';
import 'package:todo/data/sql_database.dart';
import '../screens/edit_reminder_screen.dart';
import '../helpers/date_time.dart';
import '../models/task.dart';

class TaskTile extends StatefulWidget {
  final Task task;
  final double width;

  const TaskTile({Key key, @required this.task, @required this.width})
      : super(key: key);

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  final _database = SQLDatabase();
  Future<void> _onChecked(bool value) async {
    setState(() {
      widget.task.isDone = value;
      widget.task.shouldRemind = value ? false : true;
    });
    await _database.updateTask(widget.task);
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
            DotPath(isDone: widget.task.isDone),
            TaskHolder(task: widget.task),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  children: [
                    Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: widget.task.isDone,
                      onChanged: (value) => _onChecked(value),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                                builder: (_) =>
                                    EditReminderScreen(task: widget.task)));
                      },
                      child: Text('Details'),
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
  final bool isDone;

  const DotPath({Key key, @required this.isDone}) : super(key: key);
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
            color: isDone ? Colors.grey : Colors.blue,
            size: 4.0,
          ),
          Icon(
            Icons.circle,
            color: isDone ? Colors.grey : Colors.blue,
            size: 4.0,
          ),
          Icon(
            Icons.circle,
            color: isDone ? Colors.grey : Colors.blue,
            size: 13.0,
          ),
          Icon(
            Icons.circle,
            color: isDone ? Colors.grey : Colors.blue,
            size: 4.0,
          ),
          Icon(
            Icons.circle,
            color: isDone ? Colors.grey : Colors.blue,
            size: 4.0,
          ),
          Icon(
            Icons.circle,
            color: isDone ? Colors.grey : Colors.blue,
            size: 4.0,
          ),
          Icon(
            Icons.circle,
            color: isDone ? Colors.grey : Colors.blue,
            size: 4.0,
          ),
          Icon(
            Icons.circle,
            color: isDone ? Colors.grey : Colors.blue,
            size: 4.0,
          ),
          Icon(
            Icons.circle,
            color: isDone ? Colors.grey : Colors.blue,
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
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
                decoration: task.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 3.0),
          Text(
            Format.getClockTime(
                    DateTime.fromMillisecondsSinceEpoch(task.startTime)) +
                "-" +
                Format.getClockTime(
                    DateTime.fromMillisecondsSinceEpoch(task.endTime)),
            style: TextStyle(fontSize: 12.0),
          ),
        ],
      ),
    );
  }
}
