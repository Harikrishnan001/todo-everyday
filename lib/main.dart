import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverPadding(
//             padding: const EdgeInsets.all(10.0),
//             sliver: SliverAppBar(
//               brightness: Brightness.dark,
//               expandedHeight: 180,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15.0)),
//               backgroundColor: Colors.blue[800],
//               title: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Text('March 25'),
//               ),
//               flexibleSpace: FlexibleSpaceBar(
//                 titlePadding: const EdgeInsets.only(
//                   top: 80,
//                   left: 10,
//                   right: 10,
//                   bottom: 10,
//                 ),
//                 title: Container(
//                   alignment: Alignment.center,
//                   height: 70,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10.0),
//                     color: Colors.green[600],
//                   ),
//                   child: ListView(
//                     scrollDirection: Axis.horizontal,
//                     physics: NeverScrollableScrollPhysics(),
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10.0, vertical: 15.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             DateElement('Sun', '17'),
//                             DateElement('Mon', '18'),
//                             DateElement('Tue', '19'),
//                             DateElement('Wed', '20'),
//                             DateElement('Thu', '21'),
//                             DateElement('Fri', '22'),
//                             DateElement('Sat', '23'),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SliverList(
//               delegate: SliverChildBuilderDelegate(
//             (context, index) {
//               return Container(
//                 height: 70.0,
//                 margin: const EdgeInsets.all(10.0),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10.0),
//                   color: Colors.indigo,
//                 ),
//               );
//             },
//             childCount: 15,
//           ))
//         ],
//       ),
//     );
//   }
// }

// class DateElement extends StatelessWidget {
//   final String weekDay;
//   final String monthDay;

//   const DateElement(this.weekDay, this.monthDay, [Key key]) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           weekDay,
//           style: TextStyle(
//             fontSize: 11.0,
//           ),
//         ),
//         SizedBox(height: 6.0),
//         Text(
//           monthDay,
//           style: TextStyle(
//             fontSize: 8.0,
//           ),
//         ),
//       ],
//     );
//   }
// }
