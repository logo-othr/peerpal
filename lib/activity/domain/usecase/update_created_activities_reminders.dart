import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/activity/domain/repository/activity_reminder_repository.dart';

class UpdateCreatedActivitiesRemindersUseCase {
  final ActivityReminderRepository _activityReminderRepository;

  UpdateCreatedActivitiesRemindersUseCase(this._activityReminderRepository);

  Future<void> call(List<Activity> activities) async {
    List<String> previousActivityIdsWithReminders =
        await _activityReminderRepository
                .getCreatedActivityIdsWithReminders() ??
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

    await _activityReminderRepository
        .setCreatedActivityIdsWithReminders(newIds);
  }
}
