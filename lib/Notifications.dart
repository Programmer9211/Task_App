import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_app/HomeScreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationsPlugin {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationsPlugin._privateconstructor();

  init(BuildContext context) {
    AndroidInitializationSettings androidinitializesetting =
        AndroidInitializationSettings('avatar');
    IOSInitializationSettings iosinitializesetting =
        IOSInitializationSettings();

    InitializationSettings initializationSettings =
        InitializationSettings(androidinitializesetting, iosinitializesetting);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) =>
            onNotificationSelected(payload, context));
  }

  Future<void> showNotificationSchedule(DocumentSnapshot ds, int id) async {
    AndroidNotificationDetails androiddeatils = AndroidNotificationDetails(
        "channel_Id", "Task App", "Channel_Description",
        priority: Priority.Max, importance: Importance.Max);

    IOSNotificationDetails iosdeatils = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(androiddeatils, iosdeatils);

    await flutterLocalNotificationsPlugin.showDailyAtTime(
      id,
      ds['task'],
      "Task about to start",
      Time(ds['hour'], ds['min'], 0),
      notificationDetails,
    );
  }

  Future<void> showNotificationScheduleEnd(DocumentSnapshot ds, int id) async {
    AndroidNotificationDetails androiddeatils = AndroidNotificationDetails(
        "channel_Id", "Task App", "Channel_Description",
        priority: Priority.Max, importance: Importance.Max);

    IOSNotificationDetails iosdeatils = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(androiddeatils, iosdeatils);

    await flutterLocalNotificationsPlugin.showDailyAtTime(
      id,
      ds['title'],
      "This task is about to end",
      Time(ds['hours'], ds['mins'], 0),
      notificationDetails,
    );
  }

  static final NotificationsPlugin notificationsPlugins =
      NotificationsPlugin._privateconstructor();

  onNotificationSelected(String payload, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
  }
}
