import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

const TWO_PI = 3.14 * 2;

class WorkoutComponent extends StatefulWidget {
  @required
  final Color color;
  const WorkoutComponent({
    Key key,
    this.color,
  }) : super(key: key);

  @override
  _WorkoutComponentState createState() => _WorkoutComponentState();
}

class _WorkoutComponentState extends State<WorkoutComponent>
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
    controller =
        AnimationController(duration: const Duration(seconds: 10), vsync: this);
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
    final size = 230.0;
    int percentage = (animation.value * 100).ceil();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(color: widget.color),
      child: Center(
        child: Container(
          width: size,
          height: size,
          child: Stack(
            children: [
              ShaderMask(
                shaderCallback: (rect) {
                  return SweepGradient(
                          startAngle: 0.0,
                          endAngle: TWO_PI,
                          stops: [animation.value, animation.value],
                          // 0.0 , 0.5 , 0.5 , 1.0
                          center: Alignment.center,
                          colors: [Colors.blue, Colors.transparent])
                      .createShader(rect);
                },
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
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
                    (percentage <= 30 && percentage > 20)
                        ? 'я заебался'
                        : (percentage <= 40 && percentage > 30)
                            ? 'разбираться'
                            : (percentage <= 50 && percentage > 40)
                                ? 'с этими'
                                : (percentage <= 60 && percentage > 50)
                                    ? 'ебучими'
                                    : (percentage <= 70 && percentage > 60)
                                        ? 'шейдерами'
                                        : '$percentage',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue,
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
