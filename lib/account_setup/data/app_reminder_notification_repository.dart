import 'package:peerpal/app/data/local_app_configuration_service.dart';
import 'package:peerpal/app/domain/notification/notification_service.dart';
import 'package:peerpal/app_logger.dart';
import 'package:timezone/timezone.dart';

class AppReminderNotificationRepository {
  final NotificationService _notificationService;
  final LocalAppConfigurationService _localConfiguration;

  AppReminderNotificationRepository(
      {required notificationService, required localConfiguration})
      : _notificationService = notificationService,
        _localConfiguration = localConfiguration;

  void scheduleWeeklyReminders(String title, String message) async {
    int? weeklyReminderId =
        await _localConfiguration.getWeeklyReminderNotificationId();
    if (weeklyReminderId != null) {
      await _scheduleWeekly(title, message);
    } else {
      logger.i(
          "Weekly Notification with title '$title' and message '$message' is "
          "already scheduled.");
    }
  }

  Future<void> _scheduleWeekly(String title, String message) async {
    var datetime = _nextInstanceOfMondayTenAM();
    int weeklyReminderNotificationId = await _notificationService
        .scheduleWeeklyNotification(title, message, datetime);
    await _localConfiguration
        .setWeeklyReminderNotificationId(weeklyReminderNotificationId);
  }

  // Source: flutter local notification documentation
  TZDateTime _nextInstanceOfMondayTenAM() {
    TZDateTime scheduledDate = _nextInstanceOfTenAM();
    while (scheduledDate.weekday != DateTime.monday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // Source: flutter local notification documentation
  TZDateTime _nextInstanceOfTenAM() {
    final TZDateTime now = TZDateTime.now(local);
    TZDateTime scheduledDate =
        TZDateTime(local, now.year, now.month, now.day, 10, 00);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
