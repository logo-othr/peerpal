import 'package:peerpal/app/domain/notification/notification_service.dart';

class AppReminderNotificationRepository {
  final NotificationService _notificationService;

  AppReminderNotificationRepository({required notificationService})
      : _notificationService = notificationService;

  void scheduleWeeklyReminders(String title, String message) async {
    int notificationReminderId =
        await _notificationService.scheduleWeeklyNotification(title, message);
    if (notificationReminderId == -1)
      print("error: weekly reminder could not be scheduled.");
  }
}
