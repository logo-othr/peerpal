import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class PushNotificationHelper {
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

    print(remoteNotification);

    await flutterLocalNotificationsPlugin.show(
      0,
      remoteNotification.title,
      remoteNotification.body,
      platformChannelSpecifics,
      payload: 'Notification Payload',
    );
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message ${message.data}");
    print('onResume: $message');
    if (message.notification != null) {
      //showNotification(message.notification!);
    }
    return;
  }

  static Future<void> firebaseMessagingInAppHandler(
      RemoteMessage message) async {
    print("Handling in App message ${message.data}");
    print('onMessage: $message');
    if (message.notification != null) {
      showNotification(message.notification!);
    }
    return;
  }

  static Future<void> firebaseMessagingOnOpenAppHandler(
      RemoteMessage message) async {
    print("Handling on open App message ${message.data}");
    print('onLaunch: $message');
    if (message.notification != null) {
      showNotification(message.notification!);
    }
    return;
  }
}
