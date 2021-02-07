import 'package:flutter/material.dart';
import 'package:meditation/screens/homescreen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> main() async {
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            onlyAlertOnce: true,
            playSound: false,
            enableVibration: false,
            channelKey: 'silenced',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Colors.blue,
            ledColor: Colors.white)
      ]);
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // Insert here your friendly dialog box before call the request method
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
