import 'package:flutter/material.dart';
import 'package:meditation/classes_for_workout/session_data.dart';

enum Types { breathIn, breathOut, hold }

class ArcPainter extends CustomPainter {
  final double current;
  final List<double> limits;
  final List<Types> items;
  final double toWhere1;
  final double toWhere2;

  bool done = false;

  ArcPainter(
      this.current, this.toWhere1, this.toWhere2, this.limits, this.items);

  List<Paint> painters = [
    Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20,
    Paint()
      ..color = Colors.cyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20,
    Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < items.length; i++) {
      if (current <= limits[i]) {
        canvas.drawArc(
            Offset(0, 0) & Size(250, 250),
            0, //radianss
            current, //radians
            false,
            painters[items[i].index]);
      }
    }

    if (current <= toWhere1)
      canvas.drawArc(
          Offset(0, 0) & Size(250, 250),
          0, //radianss
          current, //radians
          false,
          paint1);
    else
      canvas.drawArc(
          Offset(0, 0) & Size(250, 250),
          0, //radianss
          toWhere1, //radians
          false,
          paint1);

    if (current >= toWhere1 && current <= toWhere2) {
      canvas.drawArc(
          Offset(0, 0) & Size(250, 250),
          toWhere1, //radianss
          current - toWhere1, //radians
          false,
          paint2);
    }
    done = true;
  }

  @override
  bool shouldRepaint(ArcPainter oldDelegate) {
    return !done;
  }
}

class WorkoutArcAnimated extends StatefulWidget {
  @required
  final SessionData sessionData;

  const WorkoutArcAnimated({Key key, this.sessionData}) : super(key: key);
  @override
  _WorkoutArcAnimatedState createState() => _WorkoutArcAnimatedState();
}

class _WorkoutArcAnimatedState extends State<WorkoutArcAnimated>
    with SingleTickerProviderStateMixin {
  double current = 0;
  double toWhere1 = 2;
  double toWhere2 = 6.2831;
  Animation<double> _animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(seconds: widget.sessionData.oneCircleDuration),
        vsync: this);

    controller.forward();

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.stop();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animation = Tween(begin: 0.0, end: toWhere2).animate(controller)
      ..addListener(() {
        setState(() {
          current = _animation.value;
        });
      });

    return SizedBox(
      width: 250,
      height: 250,
      child: CustomPaint(
        painter: ArcPainter(current, toWhere1, toWhere2,
            widget.sessionData.limits, widget.sessionData.ids),
      ),
    );
  }
}
