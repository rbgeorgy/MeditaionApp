import 'package:flutter/material.dart';
import 'package:meditation/components/MainBottomNavigationBar.dart';
import 'package:meditation/components/TrainPageView.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _chooseNotifier = ValueNotifier<String>('Main Page');
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    var androidInitialize =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
      android: androidInitialize,
      iOS: iOSInitialize,
    );
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: notificationSelected);
  }

  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        'Channel ID', 'Channel Name', 'This is channel',
        importance: Importance.max);
    var iOSDetails = new IOSNotificationDetails();
    var generalNotificationsDetails =
        new NotificationDetails(android: androidDetails, iOS: iOSDetails);
    await flutterLocalNotificationsPlugin.show(
        0, 'Task', 'Body of task', generalNotificationsDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MainBottomNavigationBar(_chooseNotifier),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      floatingActionButton: new FloatingActionButton(
        onPressed: _showNotification,
        child: Icon(Icons.add),
      ),
      body: getWidget(_chooseNotifier.value, context),
    );
  }

  Future notificationSelected(String payload) async {}

  Widget getAppbar(String value, BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _chooseNotifier,
        builder: (_, value, __) => getAppbarWidget());
  }

  Widget getAppbarWidget() {
    switch (_chooseNotifier.value) {
      case 'Main Page':
        return TrainPageView();
        break;
      default:
        return Container();
    }
  }

  Widget getWidget(String value, BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _chooseNotifier,
        builder: (_, value, __) => getCenterWidget());
  }

  Widget getCenterWidget() {
    switch (_chooseNotifier.value) {
      case 'Main Page':
        return TrainPageView();
        break;
      default:
        return Container();
    }
  }
}
