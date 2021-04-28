import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:todo/data/sql_database.dart';

class StatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(10.0),
            sliver: SliverAppBar(
              backgroundColor: Colors.blue[700],
              title: Text('Statistics'),
              pinned: true,
              toolbarHeight: MediaQuery.of(context).size.height / 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              elevation: 2,
              brightness: Brightness.dark,
            ),
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Daily Analysis",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.0,
                color: Colors.blue[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          )),
          CircleStatisticsBiscut(),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Weekly Analysis",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.0,
                color: Colors.blue[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          )),
          RectangleStatisticsBiscut(
            mode: TaskGatherMode.weekly,
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Monthly Analysis",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.0,
                color: Colors.blue[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          )),
          RectangleStatisticsBiscut(
            mode: TaskGatherMode.monthly,
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Annual Analysis",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.0,
                color: Colors.blue[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          )),
          RectangleStatisticsBiscut(
            mode: TaskGatherMode.yearly,
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 30.0),
          ),
        ],
      ),
    );
  }
}

class CircleStatisticsBiscut extends StatefulWidget {
  @override
  _CircleStatisticsBiscutState createState() => _CircleStatisticsBiscutState();
}

class _CircleStatisticsBiscutState extends State<CircleStatisticsBiscut>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _blueAnimation;
  Animation<double> _redAnimation;
  Animation<double> _greenAnimation;
  double total = 0;
  double success = 0;
  double failed = 0;
  @override
  void initState() {
    SQLDatabase().getStatisticsData(TaskGatherMode.daily).then(
      (data) {
        setState(() {
          total = data.total.toDouble();
          success = data.success.toDouble();
          failed = data.failed.toDouble();
          _animationController =
              AnimationController(vsync: this, duration: Duration(seconds: 2));
          _blueAnimation = Tween<double>(
                  begin: 0,
                  end: (total - success - failed) / total * Math.pi * 2)
              .animate(CurvedAnimation(
                  parent: _animationController, curve: Curves.elasticOut));
          _greenAnimation =
              Tween<double>(begin: 0, end: success / total * Math.pi * 2)
                  .animate(CurvedAnimation(
                      parent: _animationController, curve: Curves.elasticOut));
          _redAnimation =
              Tween<double>(begin: 0, end: failed / total * Math.pi * 2)
                  .animate(CurvedAnimation(
                      parent: _animationController, curve: Curves.elasticOut));

          _blueAnimation.addListener(() {
            setState(() {});
          });

          _redAnimation.addListener(() {
            setState(() {});
          });

          _greenAnimation.addListener(() {
            setState(() {});
          });

          _animationController.forward();
        });
      },
    ).onError((error, stackTrace) {
      print("*******Something went wrong:$error");
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            height: MediaQuery.of(context).size.height / 2.5,
            child: CustomPaint(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Indicator(color: Colors.blue, text: 'Ongoing'),
                    Indicator(color: Colors.green, text: 'Completed'),
                    Indicator(color: Colors.red, text: 'Failed'),
                  ],
                ),
              ),
              painter: CircularProgressPainter(
                blue: _blueAnimation?.value ?? 0,
                green: _greenAnimation?.value ?? 0,
                red: _redAnimation?.value ?? 0,
                blueStart: -Math.pi / 2,
                greenStart: -Math.pi / 2 +
                    2 * Math.pi * (total - success - failed) / total,
                redStart: -Math.pi / 2 + 2 * Math.pi * (total - failed) / total,
              ),
            ),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double blue;
  final double green;
  final double red;
  final double blueStart;
  final double greenStart;
  final double redStart;

  const CircularProgressPainter({
    this.blue,
    this.green,
    this.red,
    this.blueStart,
    this.greenStart,
    this.redStart,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = Math.min(size.height / 2, size.width / 2);
    final bluePaint = Paint()
      ..color = Colors.blue[700]
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 18.0
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;
    final redPaint = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 18.0
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    final greenPaint = Paint()
      ..color = Colors.green
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 18.0
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.bevel;
    ;

    final greyPaint = Paint()
      ..color = Colors.grey[300]
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 18.0
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, greyPaint);
    if (blue > 0 || green > 0.0 || red > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -Math.pi / 2,
        blue,
        false,
        bluePaint,
      );
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        greenStart,
        green,
        false,
        greenPaint,
      );
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        redStart,
        red,
        false,
        redPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Indicator extends StatelessWidget {
  final String text;
  final Color color;

  const Indicator({Key key, @required this.text, @required this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.crop_square,
          color: color,
          size: 25.0,
        ),
        SizedBox(width: 3),
        Text(text),
      ],
    );
  }
}

class RectangleStatisticsBiscut extends StatefulWidget {
  final TaskGatherMode mode;

  const RectangleStatisticsBiscut({Key key, @required this.mode})
      : super(key: key);
  @override
  _RectangleStatisticsBiscutState createState() =>
      _RectangleStatisticsBiscutState();
}

class _RectangleStatisticsBiscutState extends State<RectangleStatisticsBiscut>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _blueAnimation;
  Animation<double> _greenAnimation;
  Animation<double> _redAnimation;
  double total = 0;
  double success = 0;
  double failed = 0;
  @override
  void initState() {
    SQLDatabase().getStatisticsData(widget.mode).then((data) {
      if(this.)
      setState(() {
        total = data.total.toDouble();
        success = data.success.toDouble();
        failed = data.failed.toDouble();
        _animationController =
            AnimationController(vsync: this, duration: Duration(seconds: 2));
        _blueAnimation = Tween<double>(
                begin: 0,
                end: (total - success - failed) / total >= 0
                    ? (total - success - failed) / total
                    : 0.0)
            .animate(CurvedAnimation(
                parent: _animationController, curve: Curves.elasticOut));
        _greenAnimation = Tween<double>(
                begin: 0, end: success / total >= 0 ? success / total : 0.0)
            .animate(CurvedAnimation(
                parent: _animationController, curve: Curves.elasticOut));
        _redAnimation = Tween<double>(
                begin: 0, end: failed / total >= 0 ? failed / total : 0.0)
            .animate(CurvedAnimation(
                parent: _animationController, curve: Curves.elasticOut));
        _blueAnimation.addListener(() {
          setState(() {});
        });
        _greenAnimation.addListener(() {
          setState(() {});
        });
        _redAnimation.addListener(() {
          setState(() {});
        });
        _animationController.forward();
      });
    }).onError((error, stackTrace) {
      print("Something went wrong");
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      sliver: SliverToBoxAdapter(
        child: Card(
          elevation: 2,
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: CustomPaint(
                      painter: LinearProgressPainter(
                        blue: _blueAnimation?.value ?? 0,
                        green: _greenAnimation?.value ?? 0,
                        red: _redAnimation?.value ?? 0,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Indicator(text: 'Ongoing', color: Colors.blue),
                    Indicator(text: 'Completed', color: Colors.green),
                    Indicator(text: 'Failed', color: Colors.red),
                  ],
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LinearProgressPainter extends CustomPainter {
  final double blue;
  final double green;
  final double red;

  const LinearProgressPainter({this.blue, this.green, this.red});
  @override
  void paint(Canvas canvas, Size size) {
    final bluePaint = Paint()
      ..color = Colors.blue[700]
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 22.0
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;
    final redPaint = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 22.0
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    final greenPaint = Paint()
      ..color = Colors.green
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 22.0
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.bevel;

    final greyPaint = Paint()
      ..color = Colors.grey[300]
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 22.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(0, size.height / 4),
        Offset(size.width, size.height / 4), greyPaint);
    canvas.drawLine(
        Offset(0, size.height / 4),
        Offset((size.width * blue).clamp(0, size.width), size.height / 4),
        bluePaint);
    canvas.drawLine(Offset(0, size.height / 4 + 30),
        Offset(size.width, size.height / 4 + 30), greyPaint);
    canvas.drawLine(
        Offset(0, size.height / 4 + 30),
        Offset((size.width * green).clamp(0, size.width), size.height / 4 + 30),
        greenPaint);
    canvas.drawLine(Offset(0, size.height / 4 + 60),
        Offset(size.width, size.height / 4 + 60), greyPaint);
    canvas.drawLine(
        Offset(0, size.height / 4 + 60),
        Offset((size.width * red).clamp(0, size.width), size.height / 4 + 60),
        redPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
