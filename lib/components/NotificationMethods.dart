import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';

Future<void> showNotificationWithActionButtons(
    int id, int status, String title, String body) async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          autoCancel: false,
          showWhen: false,
          id: id,
          channelKey: 'basic_channel',
          title: title,
          body: body,
          payload: {'uuid': 'user-profile-uuid'}),
      actionButtons: [
        NotificationActionButton(
            key: 'STOP',
            label: 'Stop',
            autoCancel: false,
            enabled: status == 0 ? false : true,
            buttonType: ActionButtonType.KeepOnTop),
        NotificationActionButton(
            key: 'PAUSE',
            label: status == 2 ? 'Pause' : 'Play',
            autoCancel: false,
            buttonType: ActionButtonType.KeepOnTop),
        NotificationActionButton(
            key: 'ADD_CIRCLE',
            label: 'Add circle',
            autoCancel: false,
            enabled: status == 0 ? false : true,
            buttonType: ActionButtonType.KeepOnTop),
      ]);
}
