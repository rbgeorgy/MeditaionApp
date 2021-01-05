import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meditation/components/Workout.dart';

class TrainPageView extends StatefulWidget {
  @override
  _TrainPageViewState createState() => _TrainPageViewState();
}

class _TrainPageViewState extends State<TrainPageView> {
  final _controller = new PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<WorkoutComponent> _pages = [
      WorkoutComponent(color: Theme.of(context).accentColor),
      WorkoutComponent(
        color: Colors.amber,
      ),
      WorkoutComponent(
        color: Colors.black45,
      )
    ];
    return Stack(
      children: [
        PageView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _controller,
          scrollDirection: Axis.vertical,
          children: _pages,
        ),
        new Positioned(
          bottom: 0.0,
          right: 0.0,
          top: 0.0,
          child: new Container(
            padding: const EdgeInsets.all(20.0),
            child: new Center(
              child: new DotsIndicator(
                controller: _controller,
                itemCount: _pages.length,
                onPageSelected: (int page) {
                  _controller.animateToPage(
                    page,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.white,
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
    );
  }

  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, _buildDot),
    );
  }
}
