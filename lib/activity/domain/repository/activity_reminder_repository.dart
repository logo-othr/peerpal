import 'package:peerpal/activity/domain/models/activity.dart';

abstract class ActivityReminderRepository {
  /// Deletes all existing reminders associated with the activities that the
  /// current user has joined and sets new reminders for the provided [activities].
  Future<void> setJoinedActivitiesReminders(List<Activity> activities);

  /// Deletes all existing reminders associated with the activities that the
  /// current user has created and sets new reminders for the provided [activities].
  Future<void> setCreatedActivitiesReminders(List<Activity> activities);
}
