import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class SessionData {
  @required
  final int oneCircleDuration;
  final List<Tuple2<int, int>> data;
  int numberOfCircles = 15;
  SessionData({this.oneCircleDuration, this.data});

  void addCircle() {
    numberOfCircles++;
  }
}
