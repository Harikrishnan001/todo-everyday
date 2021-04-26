import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo/data/sql_database.dart';
import 'package:todo/helpers/date_time.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';
import '../widgets/date_element.dart';

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
  final SQLDatabase _database = SQLDatabase();
  List<bool> boolList = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  // ignore: deprecated_member_use
  List<int> dayList = List<int>(8);

  void _updateDateInfo() {
    final currentDateTime = DateTime.now();
    DateTime nearestMondayDateTime;
    if (currentDateTime.weekday != 1) {
      nearestMondayDateTime =
          currentDateTime.subtract(Duration(days: currentDateTime.weekday - 1));
    } else
      nearestMondayDateTime = currentDateTime;
    boolList[currentDateTime.weekday] = true;
    for (int i = 1; i <= 7; i++) {
      dayList[i] = nearestMondayDateTime.add(Duration(days: i - 1)).day;
    }
    if (currentDateTime.weekday !=
        currentDateTime.subtract(Duration(minutes: 1)).weekday) setState(() {});
  }

  void initState() {
    _scrollController = ScrollController(
      keepScrollOffset: true,
      initialScrollOffset: 10.0,
    );
    _animationController = AnimationController(vsync: this);
    _animationController.addListener(() {
      setState(() {});
    });
    Timer.periodic(Duration(minutes: 1), (timer) {
      _updateDateInfo();
    });
    _updateDateInfo();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverAppBar(
              backgroundColor: Colors.blue[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              expandedHeight: _expandedHeight,
              pinned: true,
              elevation: 2,
              title: Row(
                children: [
                  Text(Format.getMonthName(DateTime.now())),
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
                        DateTime.now().day.toString(),
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
                  _animationController.animateTo(
                    _dateOpacity,
                    duration: Duration(
                      milliseconds: 50,
                    ),
                  );
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
                              DateElement('Mo', dayList[1].toString(),
                                  isToday: boolList[1]),
                              DateElement('Tu', dayList[2].toString(),
                                  isToday: boolList[2]),
                              DateElement('We', dayList[3].toString(),
                                  isToday: boolList[3]),
                              DateElement('Th', dayList[4].toString(),
                                  isToday: boolList[4]),
                              DateElement('Fr', dayList[5].toString(),
                                  isToday: boolList[5]),
                              DateElement('Sa', dayList[6].toString(),
                                  isToday: boolList[6]),
                              DateElement('Su', dayList[7].toString(),
                                  isToday: boolList[7]),
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
          FutureBuilder<List<Task>>(
            future: _database.getUnfinishedTasks(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return SliverToBoxAdapter(
                    child: Center(child: Text('Something went wrong')));
              }
              if ((snapshot.hasData && snapshot.data.length == 0) ||
                  !snapshot.hasData) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text('Add some task to get started'),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return TaskTile(
                      task: snapshot.data[index],
                      width: MediaQuery.of(context).size.width,
                      onUpdate: () => setState(() {}),
                    );
                  },
                  childCount: snapshot.hasData ? snapshot.data.length : 0,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
