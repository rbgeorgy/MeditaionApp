import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:meditation/classes_for_workout/session_data.dart';

const TWO_PI = 6.28318;

class WorkoutComponent2 extends StatelessWidget {
  @required
  final Color color;
  final int duration;
  WorkoutComponent2({Key key, this.color, this.duration}) : super(key: key);
  final SessionData sessionData = SessionData([2, 4], 6, [0, 1]);

  final double nessesaryRotation = -1.570795; //-pi/2
  final size = 250.0;
  final Color barColor = Colors.blue;
  final Color barColor2 = Colors.cyan;

  bool paused = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(color: color),
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
                          sessionData.fractions[0] + 0.0005,
                          sessionData.fractions[0] + 0.0005
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
                angle: nessesaryRotation + TWO_PI * sessionData.fractions[0],
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return SweepGradient(
                        startAngle: 0.0,
                        endAngle: TWO_PI,
                        stops: [
                          sessionData.fractions[1] + 0.0005,
                          sessionData.fractions[1] + 0.0005
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
              paused
                  ? SizedBox.shrink()
                  : RoundThing(
                      sessionData: sessionData,
                      barColor2: barColor2,
                      barColor: barColor,
                      size: size,
                    ),
              Center(
                //добавить штуку, которая не будет опираться на animation.value
                //у нас же есть заранее известный duration, поэтому у нас будет
                //асинхронный метод, который отображает инфу, согласно session.data
                child: Container(
                  width: size - 40,
                  height: size - 40,
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Center(
                      child: MaterialButton(
                    onPressed: () {},
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

class RoundThing extends StatefulWidget {
  RoundThing(
      {Key key, this.sessionData, this.barColor2, this.barColor, this.size})
      : super(key: key);
  @required
  final SessionData sessionData;
  final Color barColor;
  final Color barColor2;
  final double size;

  @override
  _RoundThingState createState() => _RoundThingState();
}

class _RoundThingState extends State<RoundThing>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

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
    return Stack(
      children: [
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
                        ? widget.barColor2
                        : Colors.transparent,
                    Colors.transparent
                  ]).createShader(rect);
            },
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
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
                      colors: [widget.barColor, Colors.transparent])
                  .createShader(rect);
            },
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
