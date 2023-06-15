import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/activity/domain/repository/activity_reminder_repository.dart';
import 'package:peerpal/activity/domain/usecase/calculate_upcoming_reminder_dates_usecase.dart';
import 'package:peerpal/activity/domain/usecase/has_ios_notification_permission_usecase.dart';
import 'package:peerpal/activity/domain/usecase/schedule_activity_reminder_usecase.dart';
import 'package:timezone/timezone.dart' as tz;

class UpdateCreatedActivitiesRemindersUseCase {
  final ActivityReminderRepository activityReminderRepository;
  final IsIOSWithoutNotificationPermissionUseCase
      isIOSWithoutNotificationPermission;
  final CalculateUpcomingReminderDatesUseCase filterUpcomingRemindersUseCase;
  final ScheduleActivityReminderUseCase scheduleActivityReminderUseCase;

  UpdateCreatedActivitiesRemindersUseCase({
    required this.activityReminderRepository,
    required this.filterUpcomingRemindersUseCase,
    required this.isIOSWithoutNotificationPermission,
    required this.scheduleActivityReminderUseCase,
  });

  Future<void> call(List<Activity> activities) async {
    if (await isIOSWithoutNotificationPermission())
      return; // TODO: Add error handling

    final previousActivityIdsWithReminders =
        await _fetchPreviousActivityIdsWithReminders();
    final newIds = _getActivityIds(activities);

    await _cancelPreviousReminders(previousActivityIdsWithReminders);
    await _setNewReminders(activities);

    await activityReminderRepository.setCreatedActivityIdsWithReminders(newIds);

    await activityReminderRepository.setCreatedActivityIdsWithReminders(newIds);
  }

  Future<void> _cancelPreviousReminders(List<String> activityIds) async {
    for (var activityId in activityIds) {
      await activityReminderRepository.cancelActivityReminders(activityId);
    }
  }

  Future<void> _setNewReminders(Iterable<Activity> activities) async {
    for (var activity in activities) {
      await _setActivityReminders(activity);
    }
  }

  Future<void> _setActivityReminders(Activity activity) async {
    List<tz.TZDateTime> upcomingReminders =
        await filterUpcomingRemindersUseCase(activity);
    for (tz.TZDateTime reminderDate in upcomingReminders) {
      await scheduleActivityReminderUseCase.call(activity, reminderDate,
          "${activity.name?.replaceAll('-', '')} startet demnächst.");
    }
  }

  List<String> _getActivityIds(List<Activity> activities) {
    return activities
        .where((activity) => activity.id != null)
        .map((activity) => activity.id!)
        .toList();
  }

  Future<List<String>> _fetchPreviousActivityIdsWithReminders() async {
    return await activityReminderRepository
            .getCreatedActivityIdsWithReminders() ??
        [];
  }
}
