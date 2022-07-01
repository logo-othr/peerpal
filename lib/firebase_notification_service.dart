import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:peerpal/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart';

class FirebaseNotificationService implements NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final String _ACTIVITY_NOTIFICATION_ID_COUNTER =
      'ACTIVITY_NOTIFICATION_ID_COUNTER';

  bool _isServiceInitialized = false;

  Future<int> _nextNotificationId() async {
    final SharedPreferences _preferences =
        await SharedPreferences.getInstance();
    int currentNotificationId =
        _preferences.getInt(_ACTIVITY_NOTIFICATION_ID_COUNTER) ?? 0;
    int nextNotificationId = currentNotificationId + 1;
    _preferences.setInt(_ACTIVITY_NOTIFICATION_ID_COUNTER, nextNotificationId);
    return nextNotificationId;
  }

  @override
  Future<void> startRemoteNotificationBackgroundHandler(
      firebaseMessagingBackgroundHandler) async {
    _firebaseMessaging
        .requestPermission(); // ToDo: Handle return value and errors
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp
        .listen(firebaseMessagingBackgroundHandler);
  }

  @override
  Future<int> showNotification(String title, String body,
      {String payload = ""}) async {
    await _ensureInitialized();
    int notificationId = await _nextNotificationId();
    await _flutterLocalNotificationsPlugin.show(
      notificationId,
      title,
      body,
      _platformSpecificNotificationDetails(),
      payload: payload,
    );
    print("Show notification nr. $notificationId");
    return notificationId;
  }

  @override
  Future<int> scheduleNotification(
      String title, String body, TZDateTime scheduledDateTime) async {
    await _ensureInitialized();
    int notificationId = await _nextNotificationId();
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      title,
      body,
      scheduledDateTime,
      _platformSpecificNotificationDetails(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );

    print("Scheduled notification nr. $notificationId for $scheduledDateTime");
    return notificationId;
  }

  AndroidInitializationSettings _createAndroidNotificationSettings() {
    return const AndroidInitializationSettings('@mipmap/ic_launcher');
  }

  IOSInitializationSettings _createIOSNotificationSettings() {
    return const IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
  }

  Future<void> _ensureInitialized() async {
    if (_isServiceInitialized) return;
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: _createAndroidNotificationSettings(),
            iOS: _createIOSNotificationSettings());
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    _isServiceInitialized = true;
  }

  NotificationDetails _platformSpecificNotificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails('app_notification',
          'app_notification_channel', 'App notification channel',
          importance: Importance.max, priority: Priority.max),
      iOS: IOSNotificationDetails(
        sound: 'default.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }
}
