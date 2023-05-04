import 'package:peerpal/app/domain/notification/notification_service.dart';

class RememberMeNotificationRepository {
  final NotificationService _notificationService;

  RememberMeNotificationRepository({required notificationService})
      : _notificationService = notificationService;

  void activateReminders() {
    _scheduleReminders();
  }

  Future<void> _scheduleReminders() async {
    int notificationReminderId =
        await _notificationService.scheduleWeeklyNotification();
    if (notificationReminderId == -1)
      print("error: weekly reminder could not be scheduled.");
  }
}
