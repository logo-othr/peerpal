import 'package:peerpal/account_setup/domain/app_reminder_repository.dart';
import 'package:peerpal/app/domain/notification/notification_service.dart';
import 'package:peerpal/app_logger.dart';
import 'package:timezone/timezone.dart';

/// Starts a recurring notification that reminds the user to use the app.
class WeeklyReminderUseCase {
  final AppReminderRepository _reminderRepository;
  final NotificationService _notificationService;

  WeeklyReminderUseCase({
    required appReminderRepository,
    required notificationService,
  })  : this._reminderRepository = appReminderRepository,
        this._notificationService = notificationService;

  Future<void> call(String title, String message) async {
    int? weeklyReminderId =
        await _reminderRepository.getWeeklyReminderNotificationId();

    if (weeklyReminderId == null) {
      var datetime = _nextInstanceOfMondayTenAM();
      int newReminderId = await _notificationService.scheduleWeeklyNotification(
          title, message, datetime);
      await _reminderRepository.setWeeklyReminderNotificationId(newReminderId);
    } else {
      logger.i(
          "Weekly Notification with title '$title' and message '$message' is already scheduled.");
    }
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
