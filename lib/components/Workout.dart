import 'package:flutter/material.dart';

class WorkoutComponent extends StatelessWidget {
  @required
  final Color color;
  const WorkoutComponent({
    Key key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color),
    );
  }
}
