// import 'package:flutter/material.dart';
// import 'package:flutter/animation.dart';
// import 'package:meditation/classes_for_workout/session_data.dart';

// const TWO_PI = 6.28318;

// class WorkoutComponent2 extends StatefulWidget {
//   @required
//   final Color color;
//   final int duration;
//   WorkoutComponent2({Key key, this.color, this.duration}) : super(key: key);

//   @override
//   _WorkoutComponent2State createState() => _WorkoutComponent2State();
// }

// class _WorkoutComponent2State extends State<WorkoutComponent2>
//     with SingleTickerProviderStateMixin {
//   final SessionData sessionData = SessionData([2, 4], 6, [0, 1]);

//   final double nessesaryRotation = -1.570795;
//   final size = 250.0;

//   final Color barColor = Colors.blue;

//   final Color barColor2 = Colors.cyan;

//   AnimationController controller;

//   Animation<double> animation;

//   bool paused = false;

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     controller = AnimationController(
//         duration: Duration(seconds: sessionData.oneCircleDuration),
//         vsync: this);
//     animation = Tween<double>(begin: 0, end: 1).animate(controller);

//     controller.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 30),
//       decoration: BoxDecoration(color: widget.color),
//       child: Center(
//         child: Container(
//           width: size,
//           height: size,
//           child: RotatedBox(
//             quarterTurns: -1,
//             child: Stack(
//               children: [
//                 ShaderMask(
//                   shaderCallback: (rect) {
//                     return SweepGradient(
//                         startAngle: 0.0,
//                         endAngle: TWO_PI,
//                         stops: [
//                           sessionData.fractions[0] + 0.0005,
//                           sessionData.fractions[0] + 0.0005
//                         ],
//                         center: Alignment.center,
//                         colors: [
//                           barColor.withOpacity(0.5),
//                           Colors.transparent
//                         ]).createShader(rect);
//                   },
//                   child: Container(
//                     width: size,
//                     height: size,
//                     decoration: BoxDecoration(
//                         shape: BoxShape.circle, color: Colors.white),
//                   ),
//                 ),
//                 Transform.rotate(
//                   angle: TWO_PI * sessionData.fractions[0],
//                   child: ShaderMask(
//                     shaderCallback: (rect) {
//                       return SweepGradient(
//                           startAngle: 0.0,
//                           endAngle: TWO_PI,
//                           stops: [
//                             sessionData.fractions[1] + 0.0005,
//                             sessionData.fractions[1] + 0.0005
//                           ],
//                           center: Alignment.center,
//                           colors: [
//                             barColor2.withOpacity(0.5),
//                             Colors.transparent
//                           ]).createShader(rect);
//                     },
//                     child: Container(
//                       width: size,
//                       height: size,
//                       decoration: BoxDecoration(
//                           shape: BoxShape.circle, color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 AnimatedBuilder(
//                   animation: animation,
//                   builder: (context, child) {
//                     return ShaderMask(
//                       shaderCallback: (rect) {
//                         return SweepGradient(
//                             startAngle: 0.0,
//                             endAngle: TWO_PI,
//                             stops: [animation.value, animation.value],
//                             center: Alignment.center,
//                             colors: [
//                               animation.value >= sessionData.fractions[0]
//                                   ? barColor2
//                                   : Colors.transparent,
//                               Colors.transparent
//                             ]).createShader(rect);
//                       },
//                       child: Container(
//                         width: size,
//                         height: size,
//                         decoration: BoxDecoration(
//                             shape: BoxShape.circle, color: Colors.white),
//                       ),
//                     );
//                   },
//                 ),
//                 AnimatedBuilder(
//                   animation: animation,
//                   builder: (context, child) {
//                     return ShaderMask(
//                       shaderCallback: (rect) {
//                         return SweepGradient(
//                                 startAngle: 0.0,
//                                 endAngle: TWO_PI * sessionData.fractions[0],
//                                 stops: [
//                                   animation.value *
//                                       (sessionData.unFractions[0]),
//                                   animation.value * (sessionData.unFractions[0])
//                                 ],
//                                 center: Alignment.center,
//                                 colors: [barColor, Colors.transparent])
//                             .createShader(rect);
//                       },
//                       child: Container(
//                         width: size,
//                         height: size,
//                         decoration: BoxDecoration(
//                             shape: BoxShape.circle, color: Colors.white),
//                       ),
//                     );
//                   },
//                 ),
//                 Center(
//                   child: Container(
//                     width: size - 35,
//                     height: size - 35,
//                     decoration: BoxDecoration(
//                         color: Colors.white, shape: BoxShape.circle),
//                     child: Center(
//                         child: MaterialButton(
//                       onPressed: () {},
//                     )),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
