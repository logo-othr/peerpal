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

  Future<int> scheduleWeeklyNotification();

  Future<String> printPendingNotifications();

  Future<bool> hasPermission();

  Future<bool> requestPermission();

  Future<void> cancelNotification(int notificationId);

  Future<void> cancelAll();

  Future<void> setWeeklyReminderScheduled(bool isScheduled);

  Future<void> scheduleDailyNotification();

  Future<bool> hasAskedForPermission();
}