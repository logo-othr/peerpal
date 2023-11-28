abstract class ConfigurationService {
  Future<void> setWeeklyReminderNotificationId(int notificationId);

  Future<int?> getWeeklyReminderNotificationId();
}
