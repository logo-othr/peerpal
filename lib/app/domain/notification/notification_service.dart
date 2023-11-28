import 'package:timezone/timezone.dart';

abstract class NotificationService {
  Future<void> unregisterDeviceToken();

  Future<void> registerDeviceToken();

  Future<void> startRemoteNotificationBackgroundHandler(
      firebaseMessagingBackgroundHandler, firebaseMessagingForegroundHandler);

  Future<void> stopRemoteNotificationBackgroundHandler();

  Future<int> scheduleNotification(
      String title, String body, TZDateTime scheduledDateTime);

  Future<int> showNotification(String title, String body);

  Future<int> scheduleWeeklyNotification(String title, String message);

  Future<String> printPendingNotifications();

  Future<bool> hasPermission();

  Future<bool> requestPermission();

  Future<void> cancelNotification(int notificationId);

  Future<void> cancelAll();

  Future<void> storeWeeklyReminderId(int notificationId);

  // Future<void> scheduleDailyNotification();

  Future<bool> hasAskedForPermission();
}
