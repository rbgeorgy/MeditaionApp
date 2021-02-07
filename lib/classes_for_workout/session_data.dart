import 'dart:typed_data';

import 'package:flutter/material.dart';

enum Types { breathIn, breathOut, hold }

class SessionData {
  @required
  final int oneCircleDuration;
  @required
  Float32List limits;
  Float32List audioDurationsCoefficient;
  List<int> durationLimits;
  @required
  final List<Types> ids; // begins from [0] to [.lenghs] types
  @required
  final List<int> idsDurations; // begins from [1] to [.lenghs] durations
  int numberOfCircles;

  SessionData(this.idsDurations, this.oneCircleDuration, this.ids,
      this.numberOfCircles) {
    limits = new Float32List(ids.length + 1);
    durationLimits = new List<int>(ids.length + 1);
    int sum = 0;
    audioDurationsCoefficient =
        new Float32List(ids.length); //hold 5; in 7; out 4;
    for (int i = 0; i <= ids.length; i++) {
      sum += idsDurations[i];
      if (i != ids.length) {
        int audioDuration;
        switch (ids[i]) {
          case Types.breathIn:
            audioDuration = 7;
            break;
          case Types.breathOut:
            audioDuration = 4;
            break;
          case Types.hold:
            audioDuration = 5;
            break;
          default:
        }
        audioDurationsCoefficient[i] = audioDuration / idsDurations[i];
      }
      i == 0
          ? limits[i] = 0
          : i == 1
              ? limits[i] = 6.2832 * idsDurations[i] / oneCircleDuration
              : limits[i] =
                  limits[i - 1] + 6.2832 * idsDurations[i] / oneCircleDuration;
      durationLimits[i] = sum;
    }
    durationLimits = durationLimits.reversed.toList();
  }

  void addCircle() {
    numberOfCircles++;
  }
}
