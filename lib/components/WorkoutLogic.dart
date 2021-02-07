import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meditation/classes_for_workout/session_data.dart';

typedef StringValue = void Function(String, String, String);

class WorkourLogic extends StatefulWidget {
  @required
  final SessionData sessionData;
  @required
  final StringValue callback;
  final List<String> textDatas = const ['Вдох', 'Выдох', 'Задержка'];

  WorkourLogic({Key key, this.sessionData, this.callback}) : super(key: key);

  @override
  WorkourLogicState createState() => WorkourLogicState();
}

class WorkourLogicState extends State<WorkourLogic> {
  int repeatitions;
  int secondsRemains;
  int secondsRemainsThisCircle;
  String secondsRemainsDisplay = '';
  String secondsRemainsThisCircleDisplay = '';
  Timer _timer;
  bool start = false;

  final ValueNotifier<int> secondsRemainsNotifier = new ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    repeatitions = widget.sessionData.numberOfCircles;
    secondsRemains = widget.sessionData.numberOfCircles *
        widget.sessionData.oneCircleDuration;
    secondsRemainsThisCircle = widget.sessionData.oneCircleDuration;
    secondsRemainsNotifier.value = secondsRemains;
    secondsRemainsDisplay = getTimeViewF(true, true);
    secondsRemainsThisCircleDisplay = getTimeViewF(false, true);
  }

  @override
  void dispose() {
    if (_timer != null) _timer.cancel();
    super.dispose();
  }

  String getTextData() {
    for (int i = 0; i < widget.sessionData.ids.length; i++) {
      if (secondsRemainsThisCircle + 1 >
              widget.sessionData.durationLimits[i + 1] &&
          secondsRemainsThisCircle + 1 <=
              widget.sessionData.durationLimits[i]) {
        return widget.textDatas[widget.sessionData.ids[i].index];
      }
    }
    if (secondsRemainsThisCircleDisplay == '00:00')
      return widget.textDatas[widget.sessionData.ids.last.index];
    return '';
  }

  String getTimeViewF(bool which, bool atEnd) {
    int sr = secondsRemains;
    int srtc = secondsRemainsThisCircle;
    if (atEnd) {
      sr = widget.sessionData.numberOfCircles *
          widget.sessionData.oneCircleDuration;
      secondsRemainsThisCircle = widget.sessionData.oneCircleDuration;
    }

    if (which) {
      String minutes = (sr ~/ 60).toString();
      if (minutes == '') minutes = '00';
      String secundes = (sr % 60).toString();
      if (secundes.length == 1) secundes = '0' + secundes;
      final String res = '0' + minutes + ':' + secundes;
      return res;
    } else {
      String minutes = (sr ~/ 60).toString();
      if (minutes == '') minutes = '00';
      String secundes = (srtc % 60).toString();
      if (secundes.length == 1) secundes = '0' + secundes;
      final String res = '0' + minutes + ':' + secundes;
      return res;
    }
  }

  void startTimer() {
    widget.callback('going', getTextData(), secondsRemainsDisplay);
    if (secondsRemains ==
        widget.sessionData.numberOfCircles *
            widget.sessionData.oneCircleDuration) {
      secondsRemains--;
      secondsRemainsThisCircle--;
      secondsRemainsNotifier.value = secondsRemains;
      secondsRemainsDisplay = getTimeViewF(true, false);
      secondsRemainsThisCircleDisplay = getTimeViewF(false, false);
      widget.callback('going', getTextData(), secondsRemainsDisplay);
    }
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = new Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemains == 0) {
        stopButton();
        return;
      } else {
        secondsRemains--;
        secondsRemainsThisCircle--;
        secondsRemainsNotifier.value = secondsRemains;
        secondsRemainsDisplay = getTimeViewF(true, false);
        secondsRemainsThisCircleDisplay = getTimeViewF(false, false);
        widget.callback('going', getTextData(), secondsRemainsDisplay);

        if (secondsRemainsThisCircle == 0) {
          repeatitions--;
          secondsRemainsThisCircle = widget.sessionData.oneCircleDuration;
        }
      }
    });
  }

  void pauseTimer() {
    if (_timer != null) _timer.cancel();
    secondsRemains = repeatitions * widget.sessionData.oneCircleDuration;
    secondsRemainsThisCircle = widget.sessionData.oneCircleDuration;
    secondsRemainsDisplay = getTimeViewF(true, false);
    secondsRemainsThisCircleDisplay = getTimeViewF(false, false);
    widget.callback('paused', getTextData(), secondsRemainsDisplay);
  }

  void pressOnCenterButton() {
    if (!start) {
      start = true;
      startTimer();
    } else {
      start = false;
      pauseTimer();
    }
  }

  void stopButton() {
    _timer.cancel();
    widget.callback('done', '', secondsRemainsDisplay);
    start = false;
    secondsRemainsDisplay = getTimeViewF(true, true);
    secondsRemainsThisCircleDisplay = getTimeViewF(false, true);
    secondsRemains = widget.sessionData.numberOfCircles *
        widget.sessionData.oneCircleDuration;
    secondsRemainsThisCircle = widget.sessionData.oneCircleDuration;
    repeatitions = widget.sessionData.numberOfCircles;
  }

  void addCircle() {
    secondsRemains += widget.sessionData.oneCircleDuration;
    repeatitions++;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 250,
      child: RotatedBox(
        quarterTurns: 1,
        child: ValueListenableBuilder(
          valueListenable: secondsRemainsNotifier,
          builder: (BuildContext context, int value, Widget child) {
            return Column(
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
                      color: Colors.black),
                ),
                Text(
                  // getTextData(),
                  start == true ? getTextData() : '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                Text(
                  '\nКруг\n$secondsRemainsThisCircleDisplay',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
