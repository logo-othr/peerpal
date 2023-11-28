import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:peerpal/app/data/user_database_contract.dart';
import 'package:peerpal/app/domain/notification/notification_service.dart';
import 'package:peerpal/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart';

class FirebaseNotificationService implements NotificationService {
  final String REGISTER_DEVICE_TOKEN_ERROR =
      "An error occurred while registering the device token. ";
  final String REMOVE_DEVICE_TOKEN_ERROR =
      "An error occurred while removing the device token. ";
  final String _ACTIVITY_NOTIFICATION_ID_COUNTER =
      'ACTIVITY_NOTIFICATION_ID_COUNTER';
  final String HAS_ASKED_FOR_PERMISSION = "HAS_ASKED_FOR_PERMISSION";
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
  Future<void> startRemoteNotificationBackgroundHandler(
      firebaseMessagingBackgroundHandler,
      firebaseMessagingForegroundHandler) async {
    if (!_isRemoteMessageHandlerStarted) {
      //  _firebaseMessaging
      //      .requestPermission(); // ToDo: Handle return value and errors
      FirebaseMessaging.onBackgroundMessage(
          firebaseMessagingBackgroundHandler); // ToDo: Firebase shows the notification whether it is shown via local notification or not. Investigate. https://stackoverflow.com/questions/70921767/notification-show-twice-on-flutter/71461142#71461142
      FirebaseMessaging.onMessage.listen(firebaseMessagingForegroundHandler);

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
  Future<void> cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  @override
  Future<void> cancelNotification(int notificationId) async {
    await _flutterLocalNotificationsPlugin.cancel(notificationId);
    logger.i("notification service: canceled notification ${notificationId}");
  }

  @override
  Future<String> printPendingNotifications() async {
    logger.i("pending notifications:");
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    String pendingNotifications = "";
    for (PendingNotificationRequest pendingNotificationRequest
        in pendingNotificationRequests) {
      logger.i(
          "PendingNotificationRequest: id: ${pendingNotificationRequest.id}, body: ${pendingNotificationRequest.body} payload: ${pendingNotificationRequest.payload}, title: ${pendingNotificationRequest.title}");
      pendingNotifications +=
          "PendingNotificationRequest: id: ${pendingNotificationRequest.id}, body: ${pendingNotificationRequest.body} payload: ${pendingNotificationRequest.payload}, title: ${pendingNotificationRequest.title}" +
              " /// ";
    }
    return pendingNotifications;
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
      payload: scheduledDateTime.toString(),
      androidAllowWhileIdle: true,
    );

    logger
        .i("Scheduled notification nr. $notificationId for $scheduledDateTime");
    return notificationId;
  }

  @override
  Future<bool> hasPermission() async {
    NotificationSettings currentSettings =
        await _firebaseMessaging.getNotificationSettings();

    //https://firebase.flutter.dev/docs/messaging/permissions/
    if (currentSettings.authorizationStatus == AuthorizationStatus.authorized) {
      logger.i('User granted permission');
    } else if (currentSettings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      logger.i('User granted provisional permission');
    } else {
      logger.i('User declined or has not accepted permission');
    }
    return currentSettings.authorizationStatus ==
        AuthorizationStatus.authorized;
  }

  @override
  Future<bool> requestPermission() async {
    if (await hasPermission()) {
      return true;
    }
    NotificationSettings newSettings =
        await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    final SharedPreferences _preferences =
        await SharedPreferences.getInstance();
    _preferences.setBool(HAS_ASKED_FOR_PERMISSION, true);

    return newSettings.authorizationStatus == AuthorizationStatus.authorized;
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
      android: AndroidNotificationDetails(
          'app_notification', 'app_notification_channel',
          channelDescription: 'App notification channel',
          importance: Importance.max,
          priority: Priority.max),
      iOS: DarwinNotificationDetails(
        sound: 'default.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

// ===========

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
          "${REGISTER_DEVICE_TOKEN_ERROR}. Error: ${error.payload.toString()}");
    });
  }



  @override
  Future<int> scheduleWeeklyNotification(
      String title, String message, TZDateTime datetime) async {
    await _ensureInitialized();
    int notificationId = await _nextNotificationId();
    await _flutterLocalNotificationsPlugin.zonedSchedule(notificationId, title,
        message, datetime, _platformSpecificNotificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: "weekly reminder: " + datetime.toString(),
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);

    logger.i("Scheduled weekly notification with id $notificationId");

    return notificationId;
  }

  AndroidInitializationSettings _createAndroidNotificationSettings() {
    return const AndroidInitializationSettings('@mipmap/ic_launcher');
  }

  DarwinInitializationSettings _createIOSNotificationSettings() {
    return const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
  }

  @override
  Future<bool> hasAskedForPermission() async {
    final SharedPreferences _preferences =
        await SharedPreferences.getInstance();
    return await _preferences.getBool(HAS_ASKED_FOR_PERMISSION) ?? false;
  }
}
