import 'package:flutter/material.dart';
import 'package:meditation/classes_for_workout/session_data.dart';

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
      ..color = Colors.deepPurple.withOpacity(0.5)
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
  bool shouldRepaint(ArcPainterUnanimated oldDelegate) => false;
}
