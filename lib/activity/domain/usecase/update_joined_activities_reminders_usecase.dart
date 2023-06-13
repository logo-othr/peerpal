import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/activity/domain/repository/activity_reminder_repository.dart';
import 'package:peerpal/activity/domain/usecase/calculate_upcoming_reminder_dates_usecase.dart';
import 'package:timezone/timezone.dart' as tz;

class UpdateJoinedActivitiesRemindersUseCase {
  final ActivityReminderRepository activityReminderRepository;

  final CalculateUpcomingReminderDatesUseCase filterUpcomingRemindersUseCase;

  UpdateJoinedActivitiesRemindersUseCase({
    required this.activityReminderRepository,
    required this.filterUpcomingRemindersUseCase,
  });

  Future<void> call(List<Activity> activities) async {
    List<String> previousActivityIdsWithReminders =
        await activityReminderRepository.getJoinedActivityIdsWithReminders() ??
            [];

    List<String> newIds = activities
        .where((activity) => activity.id != null)
        .map((activity) => activity.id!)
        .toList();

    for (String activityId in previousActivityIdsWithReminders) {
      await activityReminderRepository.cancelActivityReminders(activityId);
    }

    for (Activity activity in activities) {
      await _setActivityReminders(activity);
    }

    await activityReminderRepository.setJoinedActivityIdsWithReminders(newIds);
  }

  Future<void> _setActivityReminders(Activity activity) async {
    List<tz.TZDateTime> upcomingReminders =
        await filterUpcomingRemindersUseCase(activity);
    for (tz.TZDateTime reminderDate in upcomingReminders) {
      await activityReminderRepository.setActivityReminder(
          activity, reminderDate);
    }
  }
}
