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
  PageController _controller;
  String sessionState; // done going paused
  GlobalKey<WorkoutArcAnimatedState> _keyWorkoutArcAnimatedState = GlobalKey();

  @override
  void initState() {
    _controller = new PageController();
    sessionState = 'done';
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(sessionState);
    List<Widget> _pages = [
      Center(
          child: RotatedBox(
              quarterTurns: -1,
              child: Stack(children: [
                //WorkoutUnanimated(sessionData: widget.list[0]),
                WorkoutUnanimated(sessionData: widget.list[0]),
                Builder(
                    builder: (context) => WorkoutArcAnimated(
                          key: _keyWorkoutArcAnimatedState,
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
          physics: sessionState != 'done'
              ? NeverScrollableScrollPhysics()
              : AlwaysScrollableScrollPhysics(),
          controller: _controller,
          scrollDirection: Axis.vertical,
          children: _pages,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 70,
          child: AppBar(
            // backgroundColor: Colors.blue,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Text(
                'Тренировка',
                style: TextStyle(),
              ),
            ),
            actions: sessionState == 'done'
                ? [
                    IconButton(
                        icon: Icon(Icons.play_arrow),
                        onPressed: () {
                          setState(() {
                            _keyWorkoutArcAnimatedState.currentState
                                .pressOnCenterButton();
                          });
                        }),
                    IconButton(icon: Icon(Icons.more_vert), onPressed: () {})
                  ]
                : sessionState == 'paused'
                    ? [
                        IconButton(
                            icon: Icon(Icons.exposure_plus_1),
                            onPressed: () {
                              setState(() {
                                _keyWorkoutArcAnimatedState.currentState
                                    .addCircle();
                              });
                            }),
                        IconButton(
                            icon: Icon(Icons.stop),
                            onPressed: () {
                              setState(() {
                                _keyWorkoutArcAnimatedState.currentState
                                    .stopButton();
                              });
                            }),
                        IconButton(
                            icon: Icon(Icons.play_arrow),
                            onPressed: () {
                              setState(() {
                                _keyWorkoutArcAnimatedState.currentState
                                    .pressOnCenterButton();
                              });
                            }),
                        IconButton(
                            icon: Icon(Icons.more_vert), onPressed: () {})
                      ]
                    : [
                        IconButton(
                            icon: Icon(Icons.exposure_plus_1),
                            onPressed: () {
                              setState(() {
                                _keyWorkoutArcAnimatedState.currentState
                                    .addCircle();
                              });
                            }),
                        IconButton(
                            icon: Icon(Icons.stop),
                            onPressed: () {
                              setState(() {
                                _keyWorkoutArcAnimatedState.currentState
                                    .stopButton();
                              });
                            }),
                        IconButton(
                            icon: Icon(Icons.pause),
                            onPressed: () {
                              setState(() {
                                _keyWorkoutArcAnimatedState.currentState
                                    .pressOnCenterButton();
                              });
                            }),
                        IconButton(
                            icon: Icon(Icons.more_vert), onPressed: () {})
                      ],
          ),
        ),
        Visibility(
          visible: sessionState != 'done' ? false : true,
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
