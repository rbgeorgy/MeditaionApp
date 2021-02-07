import 'package:flutter/material.dart';
import 'package:meditation/classes_for_workout/session_data.dart';
import 'package:meditation/painters/arcPainter.dart';

class WorkoutArcAnimated extends StatefulWidget {
  @required
  final SessionData sessionData;

  WorkoutArcAnimated({
    Key key,
    this.sessionData,
  }) : super(key: key);
  @override
  WorkoutArcAnimatedState createState() => WorkoutArcAnimatedState();
}

class WorkoutArcAnimatedState extends State<WorkoutArcAnimated>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController controller;
  bool start = false;
  int repeatitions;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(seconds: widget.sessionData.oneCircleDuration),
        vsync: this);
    repeatitions = widget.sessionData.numberOfCircles;

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        repeatitions--;
        controller.reset();
        if (repeatitions != 0)
          controller.forward();
        else {
          start = false;
          repeatitions = widget.sessionData.numberOfCircles;
        }
      }
    });

    _animation = Tween(begin: 0.0, end: 6.2831).animate(controller);
    // _init();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void stopButton() {
    controller.reset();
    start = false;
    repeatitions = widget.sessionData.numberOfCircles;
  }

  void addCircle() {
    repeatitions++;
  }

  void pressOnCenterButton() {
    setState(() {
      if (!start) {
        start = true;
        controller.forward();
      } else {
        start = false;
        controller.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 250,
      child: AnimatedBuilder(
        builder: (_, build) {
          return CustomPaint(
            painter: ArcPainter(_animation.value, widget.sessionData.limits,
                widget.sessionData.ids),
          );
        },
        animation: controller,
      ),
    );
  }
}
