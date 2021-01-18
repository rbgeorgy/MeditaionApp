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
  int numberOfCircles = 2;

  SessionData(this.idsDurations, this.oneCircleDuration, this.ids) {
    limits = new Float32List(ids.length + 1);
    for (int i = 0; i <= ids.length; i++) {
      i == 0
          ? limits[i] = 0
          : i == 1
              ? limits[i] = 6.2832 * idsDurations[i] / oneCircleDuration
              : limits[i] =
                  limits[i - 1] + 6.2832 * idsDurations[i] / oneCircleDuration;
    }
    print(limits);
  }

  void addCircle() {
    numberOfCircles++;
  }
}
