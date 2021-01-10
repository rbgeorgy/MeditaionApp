import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:meditation/classes_for_workout/sesiion_data.dart';
import 'package:tuple/tuple.dart';

const TWO_PI = 3.14159 * 2;

class WorkoutComponent extends StatefulWidget {
  @required
  final Color color;
  final int duration;
  const WorkoutComponent({Key key, this.color, this.duration})
      : super(key: key);

  @override
  _WorkoutComponentState createState() => _WorkoutComponentState();
}

class _WorkoutComponentState extends State<WorkoutComponent>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  SessionData sessionData =
      SessionData(oneCircleDuration: 12, data: [Tuple2(0, 4), Tuple2(1, 8)]);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(seconds: sessionData.oneCircleDuration),
        vsync: this);
    animation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final size = 250.0;
    int percentage = (animation.value * 100).ceil();
    String inner = percentage / 100 <
            sessionData.data[0].item2 / sessionData.oneCircleDuration
        ? 'вдох'
        : 'выдох';

    return SubProgressBar(
        sessionData: sessionData,
        widget: widget,
        size: size,
        animation: animation,
        percentage: percentage,
        inner: inner,
        barColor: Colors.blue,
        barColor2: Colors.cyan);
  }
}

class SubProgressBar extends StatelessWidget {
  const SubProgressBar(
      {Key key,
      @required this.sessionData,
      @required this.widget,
      @required this.size,
      @required this.animation,
      @required this.percentage,
      @required this.inner,
      @required this.barColor,
      @required this.barColor2})
      : super(key: key);

  final WorkoutComponent widget;
  final double size;
  final Animation<double> animation;
  final int percentage;
  final Color barColor;
  final Color barColor2;
  final SessionData sessionData;
  final String inner;
  final double nessesaryRotation = -3.14159 / 2.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(color: widget.color),
      child: Center(
        child: Container(
          width: size,
          height: size,
          child: Stack(
            children: [
              Transform.rotate(
                angle: -3.14159 / 2.0,
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return SweepGradient(
                        startAngle: 0.0,
                        endAngle: TWO_PI,
                        stops: [
                          sessionData.data[0].item2 /
                              sessionData.oneCircleDuration,
                          sessionData.data[0].item2 /
                              sessionData.oneCircleDuration
                        ],
                        center: Alignment.center,
                        colors: [
                          barColor.withOpacity(0.5),
                          Colors.transparent
                        ]).createShader(rect);
                  },
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                  ),
                ),
              ),
              Transform.rotate(
                angle: nessesaryRotation +
                    TWO_PI *
                        sessionData.data[0].item2 /
                        sessionData.oneCircleDuration,
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return SweepGradient(
                        startAngle: 0.0,
                        endAngle: TWO_PI,
                        stops: [
                          sessionData.data[1].item2 /
                              sessionData.oneCircleDuration,
                          sessionData.data[1].item2 /
                              sessionData.oneCircleDuration
                        ],
                        center: Alignment.center,
                        colors: [
                          barColor2.withOpacity(0.5),
                          Colors.transparent
                        ]).createShader(rect);
                  },
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                  ),
                ),
              ),
              Transform.rotate(
                angle: -3.14159 / 2.0,
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return SweepGradient(
                        startAngle: 0.0,
                        endAngle: TWO_PI,
                        stops: [animation.value, animation.value],
                        center: Alignment.center,
                        colors: [
                          animation.value >=
                                  sessionData.data[0].item2 /
                                      sessionData.oneCircleDuration
                              ? barColor2
                              : Colors.transparent,
                          Colors.transparent
                        ]).createShader(rect);
                  },
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                  ),
                ),
              ),
              Transform.rotate(
                angle: -3.14159 / 2.0,
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return SweepGradient(
                            startAngle: 0.0,
                            endAngle: TWO_PI *
                                sessionData.data[0].item2 /
                                sessionData.oneCircleDuration,
                            stops: [
                              animation.value /
                                  (sessionData.data[0].item2 /
                                      sessionData.oneCircleDuration),
                              animation.value /
                                  (sessionData.data[0].item2 /
                                      sessionData.oneCircleDuration)
                            ],
                            center: Alignment.center,
                            colors: [barColor, Colors.transparent])
                        .createShader(rect);
                  },
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: size - 40,
                  height: size - 40,
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Center(
                      child: Text(
                    '$inner',
                    style: TextStyle(
                        fontSize: 25,
                        color: animation.value >=
                                sessionData.data[0].item2 /
                                    sessionData.oneCircleDuration
                            ? barColor2
                            : barColor,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
