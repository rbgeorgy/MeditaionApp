import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:meditation/classes_for_workout/session_data.dart';
import 'package:meditation/components/DotsIndicator.dart';
import 'NotificationMethods.dart';
import 'WorkoutLogic.dart';
import 'WorkoutUnanimated.dart';
import 'WorcoutAnimated.dart';

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
  String sessionState = 'done'; // done going paused
  String breathState = '';
  String timerState = '';
  GlobalKey<WorkoutArcAnimatedState> _keyWorkoutArcAnimatedState = GlobalKey();
  GlobalKey<WorkourLogicState> _keyWorkourLogicState = GlobalKey();
  final ValueNotifier<String> sessionStateNotif = ValueNotifier<String>('done');

  void processMediaControls(actionReceived) {
    switch (actionReceived.buttonKeyPressed) {
      case 'STOP':
        print('stop');
        // setState(() {
        stop();
        // });
        break;
      case 'PAUSE':
        print('pause');
        // setState(() {
        pressOnCenterButton();
        // });
        break;
      case 'ADD_CIRCLE':
        print('add circle');
        // setState(() {
        addCircle();
        // });
        break;

      default:
        break;
    }
  }

  void pressOnCenterButton() {
    _keyWorkoutArcAnimatedState.currentState.pressOnCenterButton();
    _keyWorkourLogicState.currentState.pressOnCenterButton();
  }

  void addCircle() {
    _keyWorkoutArcAnimatedState.currentState.addCircle();
    _keyWorkourLogicState.currentState.addCircle();
  }

  void stop() {
    _keyWorkoutArcAnimatedState.currentState.stopButton();
    _keyWorkourLogicState.currentState.stopButton();
  }

  bool getStart() {
    return _keyWorkourLogicState.currentState == null
        ? false
        : _keyWorkourLogicState.currentState.start;
  }

  String getBreathStatus() {
    return getStart() ? _keyWorkourLogicState.currentState.getTextData() : '';
  }

  @override
  void initState() {
    _controller = new PageController();

    AwesomeNotifications().actionStream.listen((receivedNotification) {
      processMediaControls(receivedNotification);
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      RotatedBox(
          quarterTurns: -1,
          child: Stack(alignment: Alignment.center, children: [
            WorkoutUnanimated(sessionData: widget.list[0]),
            WorkoutArcAnimated(
              key: _keyWorkoutArcAnimatedState,
              sessionData: widget.list[0],
            ),
            WorkourLogic(
              key: _keyWorkourLogicState,
              sessionData: widget.list[0],
              callback: (sessionStateValue, breathStateValue, timerStateValue) {
                setState(() {
                  sessionState = sessionStateValue;
                  breathState = breathStateValue;
                  timerState = timerStateValue;
                });
              },
            ),
            RotatedBox(
              quarterTurns: 1,
              child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: getStart()
                      ? SizedBox(
                          height: 80,
                          width: 80,
                        )
                      : Icon(
                          Icons.play_arrow,
                          size: 80,
                          color: Colors.blue,
                        ),
                  onPressed: () {
                    // setState(() {
                    pressOnCenterButton();
                    // });
                  }),
            )
          ])),
      Center(
          child: RotatedBox(
              quarterTurns: -1,
              child: Stack(children: [
                WorkoutUnanimated(sessionData: widget.list[0]),
                WorkoutArcAnimated(sessionData: widget.list[0])
              ]))),
    ];
    return ValueListenableBuilder(
        builder: (BuildContext context, String value, Widget child) {
          sessionState != 'done'
              ? showNotificationWithActionButtons(
                  3,
                  sessionState == 'done'
                      ? 0
                      : sessionState == 'paused'
                          ? 1
                          : 2,
                  breathState,
                  timerState)
              : cancelNotification(3);
          return Container(
            child: child,
          );
        },
        valueListenable: sessionStateNotif,
        child: Stack(
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
                              // setState(() {
                              pressOnCenterButton();
                              // });
                            }),
                        IconButton(
                            icon: Icon(Icons.more_vert), onPressed: () {})
                      ]
                    : sessionState == 'paused'
                        ? [
                            IconButton(
                                icon: Icon(Icons.exposure_plus_1),
                                onPressed: () {
                                  // setState(() {
                                  addCircle();
                                  // });
                                }),
                            IconButton(
                                icon: Icon(Icons.stop),
                                onPressed: () {
                                  // setState(() {
                                  stop();
                                  // });
                                }),
                            IconButton(
                                icon: Icon(Icons.play_arrow),
                                onPressed: () {
                                  // setState(() {
                                  pressOnCenterButton();
                                  // });
                                }),
                            IconButton(
                                icon: Icon(Icons.more_vert), onPressed: () {})
                          ]
                        : [
                            IconButton(
                                icon: Icon(Icons.exposure_plus_1),
                                onPressed: () {
                                  // setState(() {
                                  addCircle();
                                  // });
                                }),
                            IconButton(
                                icon: Icon(Icons.stop),
                                onPressed: () {
                                  // setState(() {
                                  stop();
                                  // });
                                }),
                            IconButton(
                                icon: Icon(Icons.pause),
                                onPressed: () {
                                  // setState(() {
                                  pressOnCenterButton();
                                  // });
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
        )
        //   ,
        // )
        );
  }
}
