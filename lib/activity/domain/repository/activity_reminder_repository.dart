import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:timezone/timezone.dart';

abstract class ActivityReminderRepository {
  /// Deletes all existing reminders associated with the activities that the
  /// current user has joined and sets new reminders for the provided [activities].

  /// Deletes all existing reminders associated with the activities that the
  /// current user has created and sets new reminders for the provided [activities].

  Future<List<String>?> getJoinedActivityIdsWithReminders();

  Future<void> setJoinedActivityIdsWithReminders(List<String> ids);

  Future<List<String>?> getCreatedActivityIdsWithReminders();

  Future<void> setCreatedActivityIdsWithReminders(List<String> ids);

  Future<void> cancelActivityReminders(String activityId);

  Future<void> setActivityReminder(Activity activity, TZDateTime reminderDate);
}