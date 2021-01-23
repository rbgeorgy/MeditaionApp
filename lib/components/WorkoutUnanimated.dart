import 'package:flutter/material.dart';
import 'package:meditation/classes_for_workout/session_data.dart';
import 'package:meditation/painters/arcPainterUnanimated.dart';

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
