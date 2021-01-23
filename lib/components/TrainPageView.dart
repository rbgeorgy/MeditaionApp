import 'package:flutter/material.dart';
import 'package:meditation/classes_for_workout/session_data.dart';
import 'package:meditation/components/DotsIndicator.dart';
import 'WorkoutUnanimated.dart';
import 'customPaintWorkout.dart';

class TrainPageView extends StatefulWidget {
  final List<SessionData> list = [
    SessionData(
        [0, 2, 2, 2, 2],
        8,
        [
          Types.breathIn,
          Types.hold,
          Types.breathOut,
          Types.hold,
        ],
        1)
  ];

  @override
  _TrainPageViewState createState() => _TrainPageViewState();
}

class _TrainPageViewState extends State<TrainPageView> {
  final _controller = new PageController();
  String sessionState = 'done';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(sessionState);
    List<Widget> _pages = [
      Center(
          child: RotatedBox(
              quarterTurns: -1,
              child: Stack(children: [
                //WorkoutUnanimated(sessionData: widget.list[0]),
                WorkoutUnanimated(sessionData: widget.list[0]),

                Builder(
                    builder: (context) => WorkoutArcAnimated(
                          sessionData: widget.list[0],
                          callback: (value) {
                            setState(() {
                              return sessionState = value;
                            });
                          },
                        )),
              ]))),
      Center(
          child: RotatedBox(
              quarterTurns: -1,
              child: Stack(children: [
                WorkoutUnanimated(sessionData: widget.list[0]),
                WorkoutArcAnimated(sessionData: widget.list[0])
              ]))),
    ];
    return Stack(
      children: [
        PageView(
          physics: sessionState == 'going'
              ? NeverScrollableScrollPhysics()
              : AlwaysScrollableScrollPhysics(),
          controller: _controller,
          scrollDirection: Axis.vertical,
          children: _pages,
        ),
        Visibility(
          visible: sessionState == 'going' ? false : true,
          child: Positioned(
            bottom: 0.0,
            right: 0.0,
            top: 0.0,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: DotsIndicator(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageSelected: (int page) {
                    _controller.animateToPage(
                      page,
                      duration: Duration(milliseconds: 250),
                      curve: Curves.ease,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
