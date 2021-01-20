import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meditation/classes_for_workout/session_data.dart';
import 'package:just_audio/just_audio.dart';

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
  int repeatitions;
  int secondsRemains;
  int secondsRemainsThisCircle;
  String secondsRemainsDisplay;
  String secondsRemainsThisCircleDisplay;
  Timer _timer;

  // final List<AudioPlayer> players = [
  //   AudioPlayer(),
  //   AudioPlayer(),
  //   AudioPlayer()
  // ];
  // final List<bool> playersPlay = [false, false, false];

  // _init() async {
  //   try {
  //     await players[0].setAsset('assets/BreathIn1.wav');
  //     await players[1].setAsset('assets/BreathOut.wav');
  //     await players[2].setAsset('assets/Hold.wav');
  //   } catch (e) {
  //     // catch load errors: 404, invalid url ...
  //     print("An error occured $e");
  //   }
  // }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(seconds: widget.sessionData.oneCircleDuration),
        vsync: this);
    repeatitions = widget.sessionData.numberOfCircles;

    secondsRemains = 10 *
        widget.sessionData.numberOfCircles *
        widget.sessionData.oneCircleDuration;
    secondsRemainsThisCircle = 10 * widget.sessionData.oneCircleDuration;
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        repeatitions--;
        controller.reset();
        if (repeatitions != 0)
          controller.forward();
        else {
          start = false;
          secondsRemains = 10 *
              widget.sessionData.numberOfCircles *
              widget.sessionData.oneCircleDuration;
          secondsRemainsThisCircle = 10 * widget.sessionData.oneCircleDuration;
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

  void startTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = new Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (secondsRemains == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          secondsRemains--;
          secondsRemainsThisCircle--;
          secondsRemainsDisplay = secondsRemains.toString().replaceRange(
              secondsRemains.toString().length - 1,
              secondsRemains.toString().length,
              '');
          secondsRemainsThisCircleDisplay = secondsRemainsThisCircle
              .toString()
              .replaceRange(secondsRemainsThisCircle.toString().length - 1,
                  secondsRemainsThisCircle.toString().length, '');

          if (secondsRemainsDisplay == '') secondsRemainsDisplay = '0';
          if (secondsRemainsThisCircleDisplay == '')
            secondsRemainsThisCircleDisplay = '0';

          if (secondsRemainsThisCircle == 0) {
            secondsRemainsThisCircle =
                10 * widget.sessionData.oneCircleDuration;
          }
        });
      }
    });
  }

  void pauseTimer() {
    if (_timer != null) _timer.cancel();
    secondsRemains = repeatitions * widget.sessionData.oneCircleDuration * 10;
    secondsRemainsThisCircle = widget.sessionData.oneCircleDuration * 10;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 250,
      child: AnimatedBuilder(
        builder: (_, build) {
          // if (controller.isCompleted && repeatitions != 0) {
          //   repeatitions--;
          //   print(repeatitions);
          //   controller.reset();
          //   controller.forward();
          // }
          // if (repeatitions == 0) {
          //   controller.reset();
          // }
          // for (int i = 0; i < widget.sessionData.ids.length; i++) {
          //   if (_animation.value > widget.sessionData.limits[i] &&
          //       _animation.value < widget.sessionData.limits[i + 1] &&
          //       playersPlay[widget.sessionData.ids[i].index] == false) {
          //     playersPlay[widget.sessionData.ids[i].index] = true;
          //     print(widget.sessionData.audioDurationsCoefficient[i + 1]);
          //     players[widget.sessionData.ids[i].index].setSpeed(
          //         widget.sessionData.audioDurationsCoefficient[i + 1]);
          //     players[widget.sessionData.ids[i].index].play();
          //   }
          // }

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
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Тренировка\n$secondsRemainsDisplay',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                  TextData(
                                    current: _animation.value,
                                    limits: widget.sessionData.limits,
                                    items: widget.sessionData.ids,
                                  ),
                                  Text(
                                    'Круг\n$secondsRemainsThisCircleDisplay',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                  // SessionCounter(
                                  //   duration:
                                  //       widget.sessionData.oneCircleDuration,
                                  //   current: _animation.value,
                                  // ),
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
                              startTimer();
                              controller.forward();
                            } else {
                              start = false;
                              pauseTimer();
                              controller.reset();
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
      dur.toString().replaceRange(0, 3, '').replaceRange(4, 11, ''),
      style: TextStyle(
          fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
    );
  }
}
