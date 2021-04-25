import 'package:flutter/material.dart';
import 'package:todo/data/sql_database.dart';
import 'package:todo/widgets/task_tile.dart';

class FinishedTasksScreen extends StatefulWidget {
  @override
  _FinishedTasksScreenState createState() => _FinishedTasksScreenState();
}

class _FinishedTasksScreenState extends State<FinishedTasksScreen> {
  final _database = SQLDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(10.0),
            sliver: SliverAppBar(
              backgroundColor: Colors.blue[700],
              title: Text('History'),
              pinned: true,
              expandedHeight: MediaQuery.of(context).size.height / 4.5,
              flexibleSpace: FlexibleSpaceBar(),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              elevation: 2,
              brightness: Brightness.dark,
            ),
          ),
          FutureBuilder(
            future: _database.getFinishedTasks(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
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
