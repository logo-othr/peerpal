import 'package:timezone/timezone.dart';

abstract class NotificationService {
  Future<void> startRemoteNotificationBackgroundHandler(
      firebaseMessagingBackgroundHandler);

  Future<int> scheduleNotification(
      String title, String body, TZDateTime scheduledDateTime);

  Future<int> showNotification(String title, String body);
}
