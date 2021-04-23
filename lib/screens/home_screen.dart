import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';
import '../widgets/date_element.dart';
//import 'package:flutter/scheduler.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  double _expandedHeight;
  ScrollController _scrollController;
  AnimationController _animationController;
  double _dateOpacity = 0.0;

  void initState() {
    _scrollController = ScrollController(
      keepScrollOffset: true,
      initialScrollOffset: 10.0,
    );
    _animationController = AnimationController(vsync: this);
    _animationController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _expandedHeight = MediaQuery.of(context).size.height / 4.5;
    super.didChangeDependencies();
  }

  var taskList = [
    Task(
      startTime: DateTime.now().millisecondsSinceEpoch,
      endTime: DateTime.now().add(Duration(hours: 13)).millisecondsSinceEpoch,
      task: 'Physics Assignment',
      taskDescription: 'Lesson 2',
    ),
    Task(
      startTime: DateTime(2021, 4, 22, 11, 32).millisecondsSinceEpoch,
      endTime: DateTime.now().millisecondsSinceEpoch,
      task: 'Wash laundry',
      taskDescription: 'Mom will be home by 4pm',
    ),
    Task(
      startTime: DateTime.now().millisecondsSinceEpoch,
      endTime: DateTime.now().add(Duration(hours: 2)).millisecondsSinceEpoch,
      task: 'Trip planning',
      taskDescription: 'At kannan Chettan\'s house',
    ),
    Task(
      startTime: DateTime.now().millisecondsSinceEpoch,
      endTime: DateTime.now().add(Duration(hours: 13)).millisecondsSinceEpoch,
      task: 'Physics Assignment',
      taskDescription: 'Lesson 2',
    ),
    Task(
      startTime: DateTime(2021, 4, 22, 11, 32).millisecondsSinceEpoch,
      endTime: DateTime.now().millisecondsSinceEpoch,
      task: 'Wash laundry',
      taskDescription: 'Mom will be home by 4pm',
    ),
    Task(
      startTime: DateTime.now().millisecondsSinceEpoch,
      endTime: DateTime.now().add(Duration(hours: 2)).millisecondsSinceEpoch,
      task: 'Trip planning',
      taskDescription: 'At kannan Chettan\'s house',
    ),
    Task(
      startTime: DateTime.now().millisecondsSinceEpoch,
      endTime: DateTime.now().add(Duration(hours: 13)).millisecondsSinceEpoch,
      task: 'Physics Assignment',
      taskDescription: 'Lesson 2',
    ),
    Task(
      startTime: DateTime(2021, 4, 22, 11, 32).millisecondsSinceEpoch,
      endTime: DateTime.now().millisecondsSinceEpoch,
      task: 'Wash laundry',
      taskDescription: 'Mom will be home by 4pm',
    ),
    Task(
      startTime: DateTime.now().millisecondsSinceEpoch,
      endTime: DateTime.now().add(Duration(hours: 2)).millisecondsSinceEpoch,
      task: 'Trip planning',
      taskDescription: 'At kannan Chettan\'s house',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(4.0),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverAppBar(
              backgroundColor: Colors.blue[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                // borderRadius: BorderRadius.only(
                //   bottomLeft: Radius.circular(15.0),
                //   bottomRight: Radius.circular(15.0),
                //   topLeft: Radius.circular(30.0),
                //   topRight: Radius.circular(30.0),
                // ),
              ),
              expandedHeight: _expandedHeight,
              pinned: true,
              elevation: 2,
              title: Row(
                children: [
                  Text('March'),
                  SizedBox(width: 10.0),
                  Opacity(
                    opacity: _dateOpacity,
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Colors.orange[300].withOpacity(_dateOpacity),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        '19',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Icon(Icons.calendar_today_outlined),
                )
              ],
              flexibleSpace: LayoutBuilder(
                builder: (_, constraints) {
                  _dateOpacity = (190 - constraints.maxHeight).abs() / 106;
                  if (_dateOpacity < 0.2) _dateOpacity = 0;
                  _dateOpacity = _dateOpacity.clamp(0.0, 1.0);
                  _animationController.animateTo(_dateOpacity,
                      duration: Duration(
                        milliseconds: 50,
                      ));
                  // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                  //   setState(() {});
                  // });
                  return FlexibleSpaceBar(
                    background: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 80.0),
                        child: Container(
                          height: constraints.maxHeight,
                          width: constraints.maxWidth,
                          decoration: BoxDecoration(
                            color: Colors.blue[700],
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              DateElement('Su', '17'),
                              DateElement('Mo', '18'),
                              DateElement('Tu', '19', isToday: true),
                              DateElement('We', '20'),
                              DateElement('Th', '21'),
                              DateElement('Fr', '22'),
                              DateElement('Sa', '21'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              forceElevated: true,
              brightness: Brightness.dark,
            ),
          ),
          SliverPadding(padding: const EdgeInsets.all(5.0)),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (_, index) {
              return TaskTile(
                width: MediaQuery.of(context).size.width,
                task: taskList[index],
              );
            },
            childCount: taskList.length,
          )),
        ],
      ),
    );
  }
}
