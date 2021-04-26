import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String quote;
  final String author;

  const ProfileScreen({Key key, @required this.quote, @required this.author})
      : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.all(10.0),
            height: MediaQuery.of(context).size.height / 2,
            decoration: BoxDecoration(
              color: Colors.blue[700],
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.circle,
                      color: Colors.white,
                      size: 150.0,
                    ),
                    Icon(
                      Icons.person,
                      color: Colors.blue[700],
                      size: 120.0,
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Spacer(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Text(
                        'Harikrishnan',
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.fade,
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(width: 20.0),
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                    Spacer(),
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin:
                  const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 50.0),
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          height: constraints.maxHeight,
                          width: constraints.maxWidth,
                          child: ListView(
                            children: [
                              Text(
                                "\"${widget.quote}\" sdjlfskjdflsjdflksdjfl sjdflksdjlfjskl l ldsjflsdjlfkj lskjdfsjdlfkjsd ksdjfh hskdfhsdjkhj hskjdfhksj",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                ),
                                maxLines: 5,
                                overflow: TextOverflow.fade,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    children: [
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: Text("- ${widget.author}"),
                      ),
                    ],
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Spacer(),
//                     Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                         child: Text(
//                           "\"$_quote\" sdjlfskjdflsjdflksdjfl sjdflksdjlfjskl l ldsjflsdjlfkj lskjdfsjdlfkjsd ksdjfh hskdfhsdjkhj hskjdfhksj",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 17.0,
//                           ),
//                           maxLines: 5,
//                           overflow: TextOverflow.fade,
//                         )),
//                     SizedBox(height: 20.0),
//                     Row(
//                       children: [
//                         Spacer(),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 50.0),
//                           child: Text("- $_author"),
//                         ),
//                       ],
//                     ),
//                     Spacer(),
//                   ],
//                 ),