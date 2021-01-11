import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class SessionData {
  @required
  final int oneCircleDuration;
  Float32List fractions;
  Float32List unFractions;
  final List<int> ids;
  final List<int> idsDurations;
  int numberOfCircles = 15;
  SessionData(this.idsDurations, this.oneCircleDuration, this.ids) {
    fractions = new Float32List(ids.length);
    unFractions = new Float32List(ids.length);
    for (int i = 0; i < ids.length; i++) {
      fractions[i] = idsDurations[i] / oneCircleDuration;
      unFractions[i] = oneCircleDuration / idsDurations[i];
    }
  }

  void addCircle() {
    numberOfCircles++;
  }
}
