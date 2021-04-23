import 'package:flutter/material.dart';
import '../helpers/date_time.dart';
import '../models/task.dart';
import 'package:flutter/painting.dart';

class TaskTile extends StatefulWidget {
  final Task task;
  final double width;

  const TaskTile({Key key, @required this.task, @required this.width})
      : super(key: key);

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  void _onChecked(bool value) {
    setState(() {
      widget.task.isDone = value;
    });
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
            StartTime(startTime: widget.task.startTime),
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
                      onChanged: _onChecked,
                    ),
                    TextButton(
                      onPressed: () {},
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

class StartTime extends StatelessWidget {
  final int startTime;

  const StartTime({Key key, this.startTime}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 18.0),
        SizedBox(
          width: 60.0,
          height: 50.0,
          child: Text(
            Format.getClockTime(DateTime.fromMillisecondsSinceEpoch(startTime)),
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
