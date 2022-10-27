import 'package:peerpal/app_tab_view/domain/notification_service.dart';

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
  }
}
