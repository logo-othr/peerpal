import 'package:peerpal/app/domain/notification/notification_service.dart';

class RememberMeNotificationRepository {
  final NotificationService _notificationService;

  RememberMeNotificationRepository({required notificationService})
      : _notificationService = notificationService;

  void scheduleWeeklyReminders() async {
    int notificationReminderId =
        await _notificationService.scheduleWeeklyNotification(
            'Wöchentliche Erinnerung - PeerPAL',
            'Hi, wir würden uns freuen, wenn du PeerPAL diese Woche nutzt!');
    if (notificationReminderId == -1)
      print("error: weekly reminder could not be scheduled.");
  }
}
