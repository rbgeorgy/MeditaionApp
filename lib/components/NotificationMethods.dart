import 'package:awesome_notifications/awesome_notifications.dart';

//TODO: без звука, показывать всегда кнопки
Future<void> showNotificationWithActionButtons(
    int id, int status, String title, String body) async {
  if (title == '') title = 'Пауза';
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          channelKey: "silenced",
          autoCancel: false,
          showWhen: false,
          id: id,
          title: status == 2 ? title : 'Пауза',
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

Future<void> cancelNotification(int id) async {
  await AwesomeNotifications().cancel(id);
}
