import 'dart:math';

import 'package:flutter/material.dart';

class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.blue,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 30.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 1.2;

  // The distance between the center of each dot
  static const double _kDotSpacing = 60.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return new Container(
      height: _kDotSpacing,
      child: new Center(
        child: ClipOval(
          child: new Material(
            color: color.withOpacity(0.7),
            type: MaterialType.circle,
            child: new Container(
              width: _kDotSize * zoom,
              height: _kDotSize * zoom,
              child: new InkWell(
                onTap: () => onPageSelected(index),
                child: Center(
                  child: Text(''), //Сюда первые буквы названия
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, _buildDot),
    );
  }
}
