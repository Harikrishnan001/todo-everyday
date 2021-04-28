import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo/models/task.dart';

import '../main.dart';

class AlarmScheduler {
  static Future scheduleAlarmWithSound(Task task) async {
    final exists = await _checkIfAlreadyScheduled(task.id);
    if (exists) return;
    var scheduleNotificationDateTime =
        DateTime.fromMillisecondsSinceEpoch(task.endTime);
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('v1', 'Todo', 'Reminder',
            icon: 'facebooklogo',
            importance: Importance.max,
            priority: Priority.high,
            largeIcon: DrawableResourceAndroidBitmap('facebooklogo'),
            playSound: false,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        task.id,
        task.task,
        'Time\'s up!\n Did you completed the task?\nIf not better luck next time.',
        scheduleNotificationDateTime,
        platformChannelSpecifics);
  }

  static Future cancelAlarm(int id) async {
    final exists = await _checkIfAlreadyScheduled(id);
    if (exists) await flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future<bool> _checkIfAlreadyScheduled(int id) async {
    final pendingList =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    for (final pendingTask in pendingList)
      if (pendingTask.id == id) return true;
    return false;
  }
}
