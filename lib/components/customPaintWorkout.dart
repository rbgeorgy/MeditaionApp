import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meditation/classes_for_workout/session_data.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meditation/painters/arcPainter.dart';

typedef StringValue = String Function(String);

class WorkoutArcAnimated extends StatefulWidget {
  @required
  final SessionData sessionData;

  final StringValue callback;

  WorkoutArcAnimated({Key key, this.sessionData, this.callback})
      : super(key: key);
  @override
  WorkoutArcAnimatedState createState() => WorkoutArcAnimatedState();
}

class WorkoutArcAnimatedState extends State<WorkoutArcAnimated>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController controller;
  bool start = false;
  int repeatitions;
  int secondsRemains;
  int secondsRemainsThisCircle;
  String secondsRemainsDisplay = '';
  String secondsRemainsThisCircleDisplay = '';
  Timer _timer;

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
          widget.callback('done');
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
    if (_timer != null) _timer.cancel();
    super.dispose();
  }

  void stopButton() {
    _timer.cancel();
    controller.reset();
    widget.callback('done');
    start = false;
    secondsRemains = 10 *
        widget.sessionData.numberOfCircles *
        widget.sessionData.oneCircleDuration;
    secondsRemainsThisCircle = 10 * widget.sessionData.oneCircleDuration;
    repeatitions = widget.sessionData.numberOfCircles;
  }

  void addCircle() {
    secondsRemains += 10 * widget.sessionData.oneCircleDuration;
    repeatitions++;
  }

  String getTimeViewF(bool which) {
    if (which) {
      String minutes = (secondsRemains ~/ 600).toString();
      if (minutes == '') minutes = '00';
      String secundes = ((secondsRemains % 600) ~/ 10).toString();
      if (secundes.length == 1) secundes = '0' + secundes;
      final String res = '0' + minutes + ':' + secundes;
      return res;
    } else {
      String minutes = (secondsRemainsThisCircle ~/ 600).toString();
      if (minutes == '') minutes = '00';
      String secundes = ((secondsRemainsThisCircle % 600) ~/ 10).toString();
      if (secundes.length == 1) secundes = '0' + secundes;
      final String res = '0' + minutes + ':' + secundes;
      return res;
    }
  }

  void startTimer() {
    widget.callback('going');
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
          secondsRemainsDisplay = getTimeViewF(true);
          secondsRemainsThisCircleDisplay = getTimeViewF(false);

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

  void pressOnCenterButton() {
    setState(() {
      if (!start) {
        start = true;
        startTimer();
        controller.forward();
      } else {
        start = false;
        pauseTimer();
        widget.callback('paused');
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
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Тренировка\n$secondsRemainsDisplay\n',
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
                                    '\nКруг\n$secondsRemainsThisCircleDisplay',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
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
                          pressOnCenterButton();
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
