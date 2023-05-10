import 'package:peerpal/activity/domain/models/activity.dart';

abstract class ActivityReminderRepository {
  Future<void> setJoinedActivitiesReminders(List<Activity> activities);

  Future<void> setCreatedActivitiesReminders(List<Activity> activities);
}
