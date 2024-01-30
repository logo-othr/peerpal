abstract class AppConfigurationService {
  Future<void> setWeeklyReminderNotificationId(int notificationId);

  Future<int?> getWeeklyReminderNotificationId();

  Future<bool> hasAskedForPermission();

  Future<void> setAskedForNotificationPermission(bool hasAsked);

  Future<bool> isNotificationPermissionRequested();

  Future<void> setNotificationPermissionRequested();
}
