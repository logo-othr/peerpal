import 'package:peerpal/app/data/notification/exceptions/notification_permission_exception.dart';
import 'package:peerpal/app/domain/notification/notification_service.dart';

class AppReminderNotificationRepository {
  final NotificationService _notificationService;

  AppReminderNotificationRepository({required notificationService})
      : _notificationService = notificationService;

  void scheduleWeeklyReminders(String title, String message) async {
    try {
      int notificationReminderId =
          await _notificationService.scheduleWeeklyNotification(title, message);
    } on NotificationPermissionException {
      // No permission to schedule the notification.
      // Store this information, to display that
      // weekly notifications are off.
      // Otherwise this catch block can be empty.
    }
  }
}
