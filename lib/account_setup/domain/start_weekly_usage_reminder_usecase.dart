import 'package:peerpal/account_setup/data/app_reminder_notification_repository.dart';
import 'package:peerpal/app_logger.dart';

/// Starts a recurring notification that reminds the user to use the app.
class StartWeeklyUsageReminderUseCase {
  AppReminderNotificationRepository repository;

  StartWeeklyUsageReminderUseCase({
    required repository,
  }) : this.repository = repository;

  Future<void> call() async {
    logger.i("Schedule weekly reminders...");
    repository.scheduleWeeklyReminders('Wöchentliche Erinnerung - PeerPAL',
        'Hi, wir würden uns freuen, wenn du PeerPAL diese Woche nutzt!');
  }
}