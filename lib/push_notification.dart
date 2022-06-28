/*import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class PushNotificationService {
  static void configLocalNotification() {
    final AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@drawable/peerpal_logo');

    final IOSInitializationSettings initializationSettingsIOS =
        const IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void showNotification(RemoteNotification remoteNotification) async {
    const NotificationDetails platformChannelSpecifics =
        const NotificationDetails(
            android: AndroidNotificationDetails(
              'app_notification',
              'app_notification_channel',
              'Channel for all app notifications',
              playSound: true,
              priority: Priority.high,
              importance: Importance.max,
            ),
            iOS: IOSNotificationDetails());

    await flutterLocalNotificationsPlugin.show(
      0,
      remoteNotification.title,
      remoteNotification.body,
      platformChannelSpecifics,
      payload: 'Notification Payload',
    );
  }

*/
