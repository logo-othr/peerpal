import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:peerpal/app_logger.dart';
import 'package:peerpal/repository/contracts/user_database_contract.dart';
import 'package:peerpal/tabview/domain/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart';

class FirebaseNotificationService implements NotificationService {
  final String REGISTER_DEVICE_TOKEN_ERROR =
      "An error occurred while registering the device token. ";
  final String REMOVE_DEVICE_TOKEN_ERROR =
      "An error occurred while removing the device token. ";
  final String _ACTIVITY_NOTIFICATION_ID_COUNTER =
      'ACTIVITY_NOTIFICATION_ID_COUNTER';
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool _isServiceInitialized = false;
  bool _isRemoteMessageHandlerStarted = false;

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
  Future<void> unregisterDeviceToken() async {
    var currentUserId = _firebaseAuth.currentUser!.uid;
    logger.i("Removing the device token...");
    FirebaseFirestore.instance
        .collection(UserDatabaseContract.serverDeleteDeviceTokenQueue)
        .doc()
        .set({UserDatabaseContract.userId: currentUserId}).onError((error,
                stackTrace) =>
            logger.e("${REMOVE_DEVICE_TOKEN_ERROR}. Error: ${error.toString()} "
                "Stacktrace: ${stackTrace.toString()}"));
  }

  @override
  Future<void> registerDeviceToken() async {
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseMessaging.instance.getToken().then((token) {
      FirebaseFirestore.instance
          .collection(UserDatabaseContract.serverUpdateDeviceTokenQueue)
          .doc()
          .set({
        UserDatabaseContract.userId: currentUserId,
        UserDatabaseContract.deviceToken: token
      }).onError((error, stackTrace) => logger
              .e("${REGISTER_DEVICE_TOKEN_ERROR}.  Error: ${error.toString()} "
                  "Stacktrace: ${stackTrace.toString()}"));
    }).catchError((error) {
      logger.e(
          "${REGISTER_DEVICE_TOKEN_ERROR}. Error: ${error.message.toString()}");
    });
  }

  @override
  Future<void> startRemoteNotificationBackgroundHandler(
      firebaseMessagingBackgroundHandler) async {
    if (!_isRemoteMessageHandlerStarted) {
      _firebaseMessaging
          .requestPermission(); // ToDo: Handle return value and errors
      FirebaseMessaging.onBackgroundMessage(
          firebaseMessagingBackgroundHandler); // ToDo: Firebase shows the notification whether it is shown via local notification or not. Investigate. https://stackoverflow.com/questions/70921767/notification-show-twice-on-flutter/71461142#71461142
      FirebaseMessaging.onMessage.listen(firebaseMessagingBackgroundHandler);
      //  FirebaseMessaging.onMessageOpenedApp
      //      .listen(firebaseMessagingBackgroundHandler);
      _isRemoteMessageHandlerStarted = true;
    }
  }

  @override
  Future<void> stopRemoteNotificationBackgroundHandler() async {
    FirebaseMessaging.onBackgroundMessage((msg) async {});
    FirebaseMessaging.onMessage.listen((msg) async {});
    FirebaseMessaging.onMessageOpenedApp.listen((msg) async {});
    _isRemoteMessageHandlerStarted = false;
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
