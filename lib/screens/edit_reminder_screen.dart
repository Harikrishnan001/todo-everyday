import 'package:flutter/material.dart';
import 'package:todo/data/sql_database.dart';
import 'package:todo/helpers/date_time.dart';
import '../models/task.dart';

class EditReminderScreen extends StatefulWidget {
  final Task task;
  final bool editMode;

  EditReminderScreen({
    Key key,
    @required this.task,
    this.editMode = false,
  }) : super(key: key);
  @override
  _EditReminderScreenState createState() => _EditReminderScreenState();
}

class _EditReminderScreenState extends State<EditReminderScreen> {
  String _title;
  String _buttonText;
  bool _editMode;
  Task task;
  TextEditingController _nameController;
  TextEditingController _descriptionController;
  bool _isNewTask = true;
  final SQLDatabase _database = SQLDatabase();

  DateTime pickedStartTime;
  DateTime pickedEndTime;

  void initState() {
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _editMode = widget.editMode;
    if (widget.task == null) {
      _isNewTask = true;
      _title = 'Create New Task';
      _buttonText = 'Create Task';
      task = Task(
        startTime: DateTime.now().millisecondsSinceEpoch,
        endTime: DateTime.now().millisecondsSinceEpoch,
        task: '',
        taskDescription: '',
      );
      pickedStartTime = DateTime.now();
      pickedEndTime = DateTime.now();
    } else if (widget.editMode == true) {
      _isNewTask = false;
      _title = 'Edit Task';
      _buttonText = 'Save Changes';
      task = widget.task;

      pickedStartTime = DateTime.fromMillisecondsSinceEpoch(task.startTime);
      pickedEndTime = DateTime.fromMillisecondsSinceEpoch(task.endTime);
    } else {
      _isNewTask = false;
      _title = 'Task';
      _buttonText = 'Edit Task'; //////////TODO:Use carefully
      task = widget.task;

      pickedStartTime = DateTime.fromMillisecondsSinceEpoch(task.startTime);
      pickedEndTime = DateTime.fromMillisecondsSinceEpoch(task.endTime);
    }
    _nameController.text = task.task;
    _descriptionController.text = task.taskDescription;
    super.initState();
  }

  Future<void> _saveTask() async {
    if (_nameController.text.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please give a name for the task')));
      return;
    }
    if (pickedEndTime.millisecondsSinceEpoch -
            pickedStartTime.millisecondsSinceEpoch <
        0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Please consider selecting an end time greater than the start time')));
      return;
    }
    task.task = _nameController.text;
    task.taskDescription = _descriptionController.text;
    task.startTime = pickedStartTime.millisecondsSinceEpoch;
    task.endTime = pickedEndTime.millisecondsSinceEpoch;

    if (_isNewTask)
      await _database.insertTask(task);
    else
      await _database.updateTask(task);
    Navigator.of(context).pop();
  }

  Future _showStartDatePicker() async {
    final date = await showDatePicker(
        context: context,
        initialDate: DateTime.fromMillisecondsSinceEpoch(task.startTime),
        firstDate: DateTime.fromMillisecondsSinceEpoch(task.startTime),
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
        initialDate: DateTime.fromMillisecondsSinceEpoch(task.startTime),
        firstDate: DateTime.fromMillisecondsSinceEpoch(task.startTime),
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
            DateTime.fromMillisecondsSinceEpoch(task.startTime)));
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
            DateTime.fromMillisecondsSinceEpoch(task.endTime)));
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
                        enabled: _editMode || _isNewTask,
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
                                    onPressed: _isNewTask || _editMode
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
                                    onPressed: _isNewTask || _editMode
                                        ? _showEndDatePicker
                                        : null,
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
                                  onTap: _isNewTask || _editMode
                                      ? _showStartTimePicker
                                      : null,
                                ),
                                SizedBox(width: 10.0),
                                TimeBiscut(
                                  title: 'End time',
                                  time: Format.getTime(pickedEndTime),
                                  onTap: _isNewTask || _editMode
                                      ? _showEndTimePicker
                                      : null,
                                ),
                              ],
                            ),
                            Spacer(),
                            SizedBox.fromSize(
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
                            ),
                            Spacer(),
                            SwitchListTile(
                              title: Text('🔔  Remind me'),
                              value: task.shouldRemind,
                              onChanged: (value) {
                                setState(() {
                                  task.shouldRemind = value;
                                });
                              },
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: _isNewTask || _editMode
                                  ? () {
                                      _saveTask();
                                    }
                                  : () => setState(() {
                                        _editMode = !_editMode;
                                        _buttonText = _editMode
                                            ? 'Save Changes'
                                            : 'Edit Task';
                                      }),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue[700]),
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
    return InputDecorator(
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
        suffix: IconButton(
          icon: Icon(Icons.calendar_today_outlined),
          onPressed: onPressed != null ? () => onPressed() : null,
        ),
      ),
    );
  }
}
