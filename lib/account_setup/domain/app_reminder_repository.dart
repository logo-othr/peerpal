abstract class AppReminderRepository {
  Future<int?> getWeeklyReminderNotificationId();

  Future<void> setWeeklyReminderNotificationId(int id);
}
