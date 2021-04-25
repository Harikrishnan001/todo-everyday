import 'package:flutter/material.dart';
import '../screens/edit_reminder_screen.dart';
import '../screens/profile_screen.dart';
import 'finished_tasks_screen.dart';
import '../screens/statistics_screen.dart';

import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool _bottomSheetActive = false;
  void initState() {
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    super.initState();
  }

  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool _homeActive = true;
  bool _reminderActive = false;
  bool _statisticsActive = false;
  bool _profileActive = false;

  void _changeColor() {
    _homeActive = false;
    _reminderActive = false;
    _statisticsActive = false;
    _profileActive = false;
    switch (_tabController.index) {
      case 0:
        _homeActive = true;
        break;
      case 1:
        _reminderActive = true;
        break;
      case 2:
        _statisticsActive = true;
        break;
      case 3:
        _profileActive = true;
    }
    setState(() {});
  }

  void _onBottomSheetOpened() {
    setState(() {
      _bottomSheetActive = true;
    });
  }

  void _onBottomSheetClosed() {
    setState(() {
      _bottomSheetActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        elevation: 10,
        notchMargin: 1,
        child: Container(
          height: 70.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.home_rounded,
                    size: 30.0,
                    color: _homeActive ? Colors.blue[700] : Colors.grey,
                  ),
                  onPressed: () {
                    _tabController.index = 0;
                    _changeColor();
                  }),
              IconButton(
                  icon: Icon(
                    Icons.access_time,
                    size: 30.0,
                    color: _reminderActive ? Colors.blue[700] : Colors.grey,
                  ),
                  onPressed: () {
                    _tabController.index = 1;
                    _changeColor();
                  }),
              IconButton(
                  icon: Icon(
                    Icons.bar_chart,
                    size: 30.0,
                    color: _statisticsActive ? Colors.blue[700] : Colors.grey,
                  ),
                  onPressed: () {
                    _tabController.index = 2;
                    _changeColor();
                  }),
              IconButton(
                  icon: Icon(
                    Icons.person_sharp,
                    size: 30.0,
                    color: _profileActive ? Colors.blue[700] : Colors.grey,
                  ),
                  onPressed: () {
                    _tabController.index = 3;
                    _changeColor();
                  }),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          HomeScreen(),
          FinishedTasksScreen(),
          StatisticsScreen(),
          ProfileScreen(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        mini: false,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context, rootNavigator: true)
              .push(MaterialPageRoute(builder: (_) => EditReminderScreen()));
        },
        isExtended: true,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}
