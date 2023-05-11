import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/activity/domain/repository/activity_reminder_repository.dart';

class UpdateJoinedActivitiesRemindersUseCase {
  final ActivityReminderRepository _activityReminderRepository;

  UpdateJoinedActivitiesRemindersUseCase(this._activityReminderRepository);

  Future<void> call(List<Activity> activities) async {
    List<String> previousActivityIdsWithReminders =
        await _activityReminderRepository.getJoinedActivityIdsWithReminders() ??
            [];

    List<String> newIds = activities
        .where((activity) => activity.id != null)
        .map((activity) => activity.id!)
        .toList();

    for (String activityId in previousActivityIdsWithReminders) {
      await _activityReminderRepository.cancelActivityReminders(activityId);
    }

    for (Activity activity in activities) {
      await _activityReminderRepository.setActivityReminders(activity);
    }

    await _activityReminderRepository.setJoinedActivityIdsWithReminders(newIds);
  }
}
