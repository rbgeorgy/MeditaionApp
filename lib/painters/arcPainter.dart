import 'package:flutter/material.dart';
import 'package:meditation/classes_for_workout/session_data.dart';

class ArcPainter extends CustomPainter {
  final double current;
  final List<double> limits;
  final List<Types> items;

  bool done = false;

  ArcPainter(this.current, this.limits, this.items);

  final List<Paint> painters = [
    Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20,
    Paint()
      ..color = Colors.deepPurple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20,
    Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < items.length; i++) {
      if (current >= limits[i] && current < limits[i + 1]) {
        canvas.drawArc(
            Offset(0, 0) & Size(250, 250),
            limits[i], //radianss
            current - limits[i], //radians
            false,
            painters[items[i].index]);

        int j = i;
        while (j > 0) {
          canvas.drawArc(Offset(0, 0) & Size(250, 250), limits[j - 1],
              limits[j] - limits[j - 1], false, painters[items[j - 1].index]);
          j--;
        }
      }
    }
    done = true;
  }

  @override
  bool shouldRepaint(ArcPainter oldDelegate) {
    return !done;
  }
}
