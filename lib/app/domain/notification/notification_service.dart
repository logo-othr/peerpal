import 'package:timezone/timezone.dart';

abstract class NotificationService {
  Future<void> startRemoteNotificationBackgroundHandler(
      firebaseMessagingBackgroundHandler, firebaseMessagingForegroundHandler);

  Future<void> stopRemoteNotificationBackgroundHandler();

  Future<int> scheduleNotification(
      String title, String body, TZDateTime scheduledDateTime);

  Future<int> scheduleWeeklyNotification(
      String title, String message, TZDateTime datetime);

  Future<String> printPendingNotifications();

  Future<bool> hasPermission();

  Future<bool> requestPermission();

  Future<void> cancelNotification(int notificationId);

  Future<void> cancelAll();
}
