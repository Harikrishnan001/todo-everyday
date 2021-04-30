import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo/data/sql_database.dart';
import 'package:todo/widgets/task_tile.dart';

class FinishedTasksScreen extends StatefulWidget {
  final VoidCallback onDisable;
  final VoidCallback onEnable;

  const FinishedTasksScreen(
      {Key key, @required this.onDisable, @required this.onEnable})
      : super(key: key);
  @override
  _FinishedTasksScreenState createState() => _FinishedTasksScreenState();
}

class _FinishedTasksScreenState extends State<FinishedTasksScreen> {
  final _database = SQLDatabase();

  Future<void> _deleteAll() async {
    final list = await _database.getFinishedTasks();
    if (list.isEmpty) {
      widget.onDisable();
      Future.delayed(Duration(seconds: 3), () {
        widget.onEnable();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Complete some tasks before!"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    final result = await showDialog<bool>(
        context: context, builder: (context) => DeleteAwareDialog());
    if (result) {
      await _database.removeAllFinishedTasks();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(10.0),
            sliver: SliverAppBar(
              backgroundColor: Colors.blue[700],
              title: Text('History'),
              pinned: true,
              toolbarHeight: MediaQuery.of(context).size.height / 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              elevation: 2,
              brightness: Brightness.dark,
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.delete_rounded,
                    size: 30.0,
                  ),
                  onPressed: () => _deleteAll(),
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: _database.getFinishedTasks(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return SliverToBoxAdapter(
                    child: Center(child: Text('Something went wrong')));
              }
              if ((snapshot.hasData && snapshot.data.length == 0) ||
                  !snapshot.hasData) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text('Finish some tasks before'),
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

class DeleteAwareDialog extends StatelessWidget {
  final Future<void> Function() onConfirm;

  const DeleteAwareDialog({Key key, this.onConfirm}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text('Are you sure about deleting the entire history?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text('Yes'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
