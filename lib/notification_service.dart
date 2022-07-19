import 'package:timezone/timezone.dart';

abstract class NotificationService {
  Future<void> unregisterDeviceToken();

  Future<void> registerDeviceToken();

  Future<void> startRemoteNotificationBackgroundHandler(
      firebaseMessagingBackgroundHandler);

  Future<void> stopRemoteNotificationBackgroundHandler();

  Future<int> scheduleNotification(
      String title, String body, TZDateTime scheduledDateTime);

  Future<int> showNotification(String title, String body);
}