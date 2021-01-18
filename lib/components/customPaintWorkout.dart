import 'package:flutter/material.dart';
import 'package:meditation/classes_for_workout/session_data.dart';
import 'package:duration/duration.dart';

enum Types { breathIn, breathOut, hold }

class ArcPainter extends CustomPainter {
  final double current;
  final List<double> limits;
  final List<Types> items;

  bool done = false;

  ArcPainter(this.current, this.limits, this.items);

  final List<Paint> painters = [
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
      if (current >= limits[i] && current < limits[i + 1]) {
        canvas.drawArc(
            Offset(0, 0) & Size(250, 250),
            limits[i], //radianss
            current - limits[i], //radians
            false,
            painters[items[i].index]);

        int j = i;
        while (j > 0) {
          canvas.drawArc(Offset(0, 0) & Size(250, 250), limits[j - 1],
              limits[j] - limits[j - 1], false, painters[items[j - 1].index]);
          j--;
        }
      }
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
  Animation<double> _animation;
  AnimationController controller;
  bool start = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(seconds: widget.sessionData.oneCircleDuration),
        vsync: this);
    int repeatitions = widget.sessionData.numberOfCircles;

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        repeatitions--;
        print(repeatitions);
        if (repeatitions == 0) {
          controller.stop();
        } else
          controller.repeat();
      }
    });

    _animation = Tween(begin: 0.0, end: 6.2831).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
            child: Center(
                child: RotatedBox(
                    quarterTurns: 1,
                    child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        child: start
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextData(
                                    current: _animation.value,
                                    limits: widget.sessionData.limits,
                                    items: widget.sessionData.ids,
                                  ),
                                  SessionCounter(
                                    duration:
                                        widget.sessionData.oneCircleDuration,
                                    current: _animation.value,
                                  ),
                                ],
                              )
                            : Icon(
                                Icons.play_arrow,
                                size: 80,
                                color: Colors.blue,
                              ),
                        // minWidth: 50,
                        // height: 50,
                        onPressed: () {
                          setState(() {
                            if (!start) {
                              start = true;
                              controller.forward();
                            } else {
                              start = false;
                              controller.stop();
                            }
                          });
                        }))),
          );
        },
        animation: controller,
      ),
    );
  }
}

class TextData extends StatelessWidget {
  @required
  final double current;
  @required
  final List<double> limits;
  @required
  final List<Types> items;
  final List<String> textDatas = const ['Вдох', 'Выдох', 'Задержка'];

  const TextData({this.current, this.limits, this.items});

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < items.length; i++) {
      if (current >= limits[i] && current < limits[i + 1]) {
        return Text(
          textDatas[items[i].index],
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor),
        );
      }
    }
    return Text('');
  }
}

class SessionCounter extends StatelessWidget {
  @required
  final double current;
  final double oneFracTwoPi = 0.16;
  final int duration;

  const SessionCounter({this.current, this.duration});

  @override
  Widget build(BuildContext context) {
    final double res = duration - current * oneFracTwoPi * duration;
    final dur = Duration(seconds: res.toInt() + 1);
    return Text(
      dur.toString().split('.').first.padLeft(8, "0").replaceRange(0, 3, ''),
      style: TextStyle(
          fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
    );
  }
}
