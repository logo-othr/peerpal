import 'package:timezone/timezone.dart';

abstract class ActivityReminderRepository {
  Future<List<String>?> getJoinedActivityIdsWithReminders();

  Future<void> setJoinedActivityIdsWithReminders(List<String> ids);

  Future<List<String>?> getCreatedActivityIdsWithReminders();

  Future<void> setCreatedActivityIdsWithReminders(List<String> ids);

  Future<void> cancelActivityReminders(String activityId);

  Future<int> scheduleReminder(
      String activityName, String message, TZDateTime scheduledDateTime);

  Future<void> saveReminder(String activityId, int reminderId);

  Future<bool> reminderExists(String activityId);
}
