import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meditation/classes_for_workout/session_data.dart';

const TWO_PI = 6.28318;

class WorkoutComponent extends StatefulWidget {
  @required
  final Color color;
  final int duration;
  WorkoutComponent({Key key, this.color, this.duration}) : super(key: key);
  final SessionData sessionData = SessionData([2, 4], 6, [0, 1]);
  @override
  _WorkoutComponentState createState() => _WorkoutComponentState();
}

class _WorkoutComponentState extends State<WorkoutComponent>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  final double nessesaryRotation = -1.570795; //-pi/2
  final size = 250.0;
  final Color barColor = Colors.blue;
  final Color barColor2 = Colors.cyan;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(seconds: widget.sessionData.oneCircleDuration),
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
    int percentage = (animation.value * 100).ceil();
    String inner =
        percentage < widget.sessionData.fractions[0] * 100 ? 'вдох' : 'выдох';

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
                angle: -1.570795,
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return SweepGradient(
                        startAngle: 0.0,
                        endAngle: TWO_PI,
                        stops: [
                          widget.sessionData.fractions[0] + 0.0005,
                          widget.sessionData.fractions[0] + 0.0005
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
                    TWO_PI * widget.sessionData.fractions[0],
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return SweepGradient(
                        startAngle: 0.0,
                        endAngle: TWO_PI,
                        stops: [
                          widget.sessionData.fractions[1] + 0.0005,
                          widget.sessionData.fractions[1] + 0.0005
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
                angle: -1.570795,
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return SweepGradient(
                        startAngle: 0.0,
                        endAngle: TWO_PI,
                        stops: [animation.value, animation.value],
                        center: Alignment.center,
                        colors: [
                          animation.value >= widget.sessionData.fractions[0]
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
                angle: -1.570795,
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return SweepGradient(
                        startAngle: 0.0,
                        endAngle: TWO_PI * widget.sessionData.fractions[0],
                        stops: [
                          animation.value * (widget.sessionData.unFractions[0]),
                          animation.value * (widget.sessionData.unFractions[0])
                        ],
                        center: Alignment.center,
                        colors: [
                          barColor,
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
                        color:
                            animation.value >= widget.sessionData.fractions[0]
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
