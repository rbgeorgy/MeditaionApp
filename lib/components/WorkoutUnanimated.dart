import 'package:flutter/material.dart';
import 'package:meditation/classes_for_workout/session_data.dart';
import 'package:meditation/components/customPaintWorkout.dart';

class WorkoutUnanimated extends StatelessWidget {
  @required
  final SessionData sessionData;

  const WorkoutUnanimated({Key key, this.sessionData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 250,
      child: CustomPaint(
        painter: ArcPainterUnanimated(sessionData.limits, sessionData.ids),
      ),
    );
  }
}

class ArcPainterUnanimated extends CustomPainter {
  final List<double> limits;
  final List<Types> items;

  ArcPainterUnanimated(this.limits, this.items);

  List<Paint> painters = [
    Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20,
    Paint()
      ..color = Colors.cyan.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20,
    Paint()
      ..color = Colors.amber.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < limits.length - 1; i++) {
      canvas.drawArc(Offset(0, 0) & Size(250, 250), limits[i],
          limits[i + 1] - limits[i], false, painters[items[i].index]);
    }
  }

  @override
  bool shouldRepaint(ArcPainter oldDelegate) => false;
}
