import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:meditation/components/customPaintWorkout.dart';

class SessionData {
  @required
  final int oneCircleDuration;
  @required
  Float32List limits;
  @required
  final List<Types> ids;
  @required
  final List<int> idsDurations;
  int numberOfCircles = 15;

  SessionData(this.idsDurations, this.oneCircleDuration, this.ids) {
    limits = new Float32List(ids.length);
    for (int i = 0; i < ids.length; i++) {
      i == 0
          ? limits[i] = 6.2832 * idsDurations[i] / oneCircleDuration
          : limits[i] =
              limits[i - 1] + 6.2832 * idsDurations[i] / oneCircleDuration;
    }
  }

  void addCircle() {
    numberOfCircles++;
  }
}
