import 'package:peerpal/activity/domain/models/activity.dart';

abstract class ActivityReminderRepository {
  Future<void> setAllReminders(List<Activity> activities);

  Future<void> cancelActivityReminders(String activityId);

  Future<void> setActivityReminders(Activity activity);
}
