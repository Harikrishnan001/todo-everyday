import 'package:flutter/material.dart';
import 'package:todo/data/sql_database.dart';
import 'package:todo/helpers/alarm_scheduler.dart';
import 'package:todo/helpers/date_time.dart';
import '../models/task.dart';

class EditReminderScreen extends StatefulWidget {
  final Task task;
  final bool editMode;

  EditReminderScreen({
    Key key,
    this.task,
    this.editMode = false,
  }) : super(key: key);
  @override
  _EditReminderScreenState createState() => _EditReminderScreenState();
}

class _EditReminderScreenState extends State<EditReminderScreen> {
  String _title;
  String _buttonText;
  bool _editMode;
  Task _task;
  TextEditingController _nameController;
  TextEditingController _descriptionController;
  bool _isNewTask = true;
  bool _buttonActive = true;
  bool _snackBarShowing = false;
  final SQLDatabase _database = SQLDatabase();
  AlarmScheduler _alarmScheduler = AlarmScheduler();

  DateTime pickedStartTime;
  DateTime pickedEndTime;

  void initState() {
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _editMode = widget.editMode;
    if (widget.task == null) {
      final dateTime = DateTime.now();
      _isNewTask = true;
      _buttonActive = true;
      _title = 'Create New Task';
      _buttonText = 'Create Task';
      _task = Task(
        startTime: dateTime.millisecondsSinceEpoch,
        endTime: dateTime.millisecondsSinceEpoch,
        task: '',
        taskDescription: '',
      );
      pickedStartTime = dateTime;
      pickedEndTime = dateTime;
    } else if (widget.editMode == true) {
      _isNewTask = false;
      _title = 'Edit Task';
      _buttonText = 'Save Changes';
      _task = widget.task;
      _editMode = true;

      pickedStartTime = DateTime.fromMillisecondsSinceEpoch(_task.startTime);
      pickedEndTime = DateTime.fromMillisecondsSinceEpoch(_task.endTime);
    } else {
      _isNewTask = false;
      _title = 'Task';
      _buttonText = 'Edit Task';
      _task = widget.task;
      _editMode = false;

      pickedStartTime = DateTime.fromMillisecondsSinceEpoch(_task.startTime);
      pickedEndTime = DateTime.fromMillisecondsSinceEpoch(_task.endTime);
    }
    _nameController.text = _task.task;
    _descriptionController.text = _task.taskDescription;
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (_nameController.text.length == 0) {
      if (!_snackBarShowing) {
        setState(() {
          _snackBarShowing = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please give a name for the task')));
        Future.delayed(Duration(seconds: 2), () {
          if (mounted)
            setState(() {
              _snackBarShowing = false;
            });
        });
      }
      setState(() {
        _buttonActive = true;
      });
      return;
    }
    if (pickedEndTime.millisecondsSinceEpoch -
            pickedStartTime.millisecondsSinceEpoch <
        0) {
      if (!_snackBarShowing) {
        setState(() {
          _snackBarShowing = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Please consider selecting an end time greater than the start time'),
        ));
        Future.delayed(Duration(seconds: 2), () {
          if (mounted)
            setState(() {
              _snackBarShowing = false;
            });
        });
      }
      setState(() {
        _buttonActive = true;
      });
      return;
    }
    _task.task = _nameController.text;
    _task.taskDescription = _descriptionController.text;
    _task.startTime = pickedStartTime.millisecondsSinceEpoch;
    _task.endTime = pickedEndTime.millisecondsSinceEpoch;
    try {
      if (_isNewTask)
        await _database.insertTask(_task);
      else
        await _database.updateTask(_task);
      if (_isNewTask) _task = await _database.getLastInsertedTask();
      if (_isNewTask || _editMode) {
        print("should remind:${_task.shouldRemind}");
        if (_task.shouldRemind) {
          if (!_isNewTask) await _alarmScheduler.cancelAlarm(_task.id);
          await _alarmScheduler.scheduleAlarmWithSound(_task);
        } else {
          await _alarmScheduler.cancelAlarm(_task.id);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'ERROR:$e \nPlease consider reporting this error to the developer')));
      print(e);
    } finally {
      setState(() {
        _buttonActive = true;
      });
    }
    Navigator.of(context).pop();
  }

  Future _showStartDatePicker() async {
    final date = await showDatePicker(
        context: context,
        initialDate: DateTime.fromMillisecondsSinceEpoch(_task.startTime),
        firstDate: DateTime.fromMillisecondsSinceEpoch(_task.startTime),
        lastDate: DateTime(3000));
    if (date == null) return;
    if (date != null) {
      {
        if (date.microsecondsSinceEpoch >
            DateTime.now().millisecondsSinceEpoch) {
          pickedStartTime = DateTime(
            date.year,
            date.month,
            date.day,
            pickedStartTime.hour,
            pickedStartTime.minute,
            pickedStartTime.second,
            pickedStartTime.millisecond,
            pickedStartTime.microsecond,
          );
          setState(() {});
        }
      }
    }
  }

  Future _showEndDatePicker() async {
    final date = await showDatePicker(
        context: context,
        initialDate: DateTime.fromMillisecondsSinceEpoch(_task.startTime),
        firstDate: DateTime.fromMillisecondsSinceEpoch(_task.startTime),
        lastDate: DateTime(3000));
    if (date == null) return;
    if (date != null) {
      {
        if (date.microsecondsSinceEpoch >
            DateTime.now().millisecondsSinceEpoch) {
          pickedEndTime = DateTime(
            date.year,
            date.month,
            date.day,
            pickedEndTime.hour,
            pickedEndTime.minute,
            pickedEndTime.second,
            pickedEndTime.millisecond,
            pickedEndTime.microsecond,
          );
          setState(() {});
        }
      }
    }
  }

  Future<void> _showStartTimePicker() async {
    final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
            DateTime.fromMillisecondsSinceEpoch(_task.startTime)));
    if (time == null) return;
    if (time != null) {
      final selectedDateTime = DateTime(
        pickedStartTime.year,
        pickedStartTime.month,
        pickedStartTime.day,
        time.hour,
        time.minute,
        pickedStartTime.second,
        pickedStartTime.millisecond,
        pickedStartTime.microsecond,
      );
      pickedStartTime = selectedDateTime;
      setState(() {});
    }
  }

  Future<void> _showEndTimePicker() async {
    final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
            DateTime.fromMillisecondsSinceEpoch(_task.endTime)));
    if (time != null) {
      final selectedDateTime = DateTime(
        pickedEndTime.year,
        pickedEndTime.month,
        pickedEndTime.day,
        time.hour,
        time.minute,
        pickedEndTime.second,
        pickedEndTime.millisecond,
        pickedEndTime.microsecond,
      );
      pickedEndTime = selectedDateTime;
      setState(() {});
    }
  }

  Color color = Colors.black;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[700],
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  color: Colors.blue[700],
                  child: Column(
                    children: [
                      SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19.0,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 35.0,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      TextField(
                        enabled: _editMode,
                        keyboardType: TextInputType.name,
                        controller: _nameController,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        height: constraints.maxHeight,
                        width: constraints.maxWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox.fromSize(
                                  size: Size(constraints.maxWidth / 2 - 10,
                                      constraints.maxHeight / 6),
                                  child: CalendarDatePicker(
                                    pickedDate: pickedStartTime,
                                    onPressed: _editMode && _isNewTask
                                        ? _showStartDatePicker
                                        : null,
                                    title: 'Start date',
                                  ),
                                ),
                                SizedBox.fromSize(
                                  size: Size(constraints.maxWidth / 2 - 10,
                                      constraints.maxHeight / 6),
                                  child: CalendarDatePicker(
                                    pickedDate: pickedEndTime,
                                    onPressed:
                                        _editMode ? _showEndDatePicker : null,
                                    title: 'End date',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                TimeBiscut(
                                  title: 'Start time',
                                  time: Format.getTime(pickedStartTime),
                                  onTap: _editMode && _isNewTask
                                      ? _showStartTimePicker
                                      : null,
                                ),
                                SizedBox(width: 10.0),
                                TimeBiscut(
                                  title: 'End time',
                                  time: Format.getTime(pickedEndTime),
                                  onTap: _editMode ? _showEndTimePicker : null,
                                ),
                              ],
                            ),
                            Spacer(),
                            _editMode
                                ? SizedBox.fromSize(
                                    size: Size(constraints.maxWidth,
                                        constraints.maxHeight / 4.8),
                                    child: TextField(
                                      enabled: _editMode || _isNewTask,
                                      maxLines: 2,
                                      controller: _descriptionController,
                                      decoration: InputDecoration(
                                        labelText: 'Description',
                                      ),
                                    ),
                                  )
                                : SizedBox.fromSize(
                                    size: Size(constraints.maxWidth,
                                        constraints.maxHeight / 4.8),
                                    child: SingleChildScrollView(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Text(
                                          "${_descriptionController.text}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17.0,
                                          ),
                                          maxLines: 4,
                                        ),
                                      ),
                                    ),
                                  ),
                            Spacer(),
                            _editMode
                                ? SwitchListTile(
                                    title: Text('🔔  Remind me'),
                                    value: _task.shouldRemind,
                                    onChanged: _isNewTask || _editMode
                                        ? (remind) {
                                            setState(() {
                                              _task.shouldRemind = remind;
                                            });
                                          }
                                        : null,
                                  )
                                : SizedBox(),
                            Spacer(),
                            TextButton(
                              onPressed: _buttonActive
                                  ? (_editMode
                                      ? () {
                                          setState(() {
                                            _buttonActive = false;
                                          });
                                          _saveTask();
                                        }
                                      : () => setState(() {
                                            _editMode = true;
                                            _title = 'Edit Task';
                                            _buttonText = 'Save Changes';
                                          }))
                                  : null,
                              style: ButtonStyle(
                                backgroundColor: _buttonActive
                                    ? MaterialStateProperty.all<Color>(
                                        Colors.blue[700])
                                    : MaterialStateProperty.all<Color>(
                                        Colors.grey),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40.0),
                                child: Text(
                                  _buttonText,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimeBiscut extends StatelessWidget {
  final String title;
  final String time;
  final VoidCallback onTap;

  const TimeBiscut(
      {Key key,
      @required this.title,
      @required this.time,
      @required this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          height: 60.0,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                children: [
                  Spacer(),
                  Icon(Icons.timer),
                  Spacer(),
                ],
              ),
              SizedBox(width: 2.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CalendarDatePicker extends StatelessWidget {
  final DateTime pickedDate;
  final VoidCallback onPressed;
  final String title;

  const CalendarDatePicker(
      {Key key,
      @required this.pickedDate,
      @required this.onPressed,
      @required this.title})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed != null ? () => onPressed() : null,
      child: InputDecorator(
        child: Text(
          Format.getCalendarDate(DateTime.fromMillisecondsSinceEpoch(
              pickedDate.millisecondsSinceEpoch)),
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14.0,
          ),
        ),
        decoration: InputDecoration(
          labelText: title,
          suffix: Icon(Icons.calendar_today_outlined),
        ),
      ),
    );
  }
}
