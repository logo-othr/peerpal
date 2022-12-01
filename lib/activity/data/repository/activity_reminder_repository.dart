import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/app_logger.dart';
import 'package:peerpal/app_tab_view/domain/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/src/date_time.dart';
import 'package:timezone/timezone.dart' as tz;

class ActivityReminderRepository {
  final SharedPreferences _prefs;
  final NotificationService _notificationService;
  final String _ACTIVITY_REMINDER_PREFIX = 'ACT_REM_';
  final String _ACTIVITY_IDS_WITH_REMINDERS_LIST =
      '_ACTIVITY_IDS_WITH_REMINDERS_LIST';

  ActivityReminderRepository({required prefs, required notificationService})
      : _prefs = prefs,
        _notificationService = notificationService;

  Future<void> clearAndSetActivityReminders(List<Activity> activities) async {
    List<String>? oldActivityWithReminderList =
        await _prefs.getStringList("${_ACTIVITY_IDS_WITH_REMINDERS_LIST}");

    List<String> newActivityWithReminderList =
        activities.map((e) => e.id ?? "-1").toList();

    if (oldActivityWithReminderList != null) {
      for (String oldActivity in oldActivityWithReminderList) {
        if (!newActivityWithReminderList.contains(oldActivity)) {
          await cancelReminderForActivity(oldActivity);
          (await _prefs.setStringList(
              _ACTIVITY_IDS_WITH_REMINDERS_LIST, newActivityWithReminderList));
        }
      }
    }

    for (Activity activity in activities) {
      await setActivityRemindersIfRemindersNotExist(activity);
    }
  }

// ToDo: Nullcheck activity member
  Future<void> setActivityRemindersIfRemindersNotExist(
      Activity activity) async {
    int firstActivityMinuteDelay = 60;
    int secondActivityDayDelay = 1;

    TZDateTime firstReminderDateTime =
        TZDateTime.fromMillisecondsSinceEpoch(tz.local, activity.date!);
    firstReminderDateTime = firstReminderDateTime
        .subtract(new Duration(minutes: firstActivityMinuteDelay));
    TZDateTime secondReminderDateTime =
        TZDateTime.fromMillisecondsSinceEpoch(tz.local, activity.date!);
    secondReminderDateTime = secondReminderDateTime
        .subtract(new Duration(days: secondActivityDayDelay));
    TZDateTime now = tz.TZDateTime.from(DateTime.now(), tz.local);

    if (firstReminderDateTime.isAfter(now)) {
      await _setActivityReminderIfReminderNotExist(
          activity,
          firstReminderDateTime,
          "Bald startet die Aktivität ${activity.name}.");
    }
    if (secondReminderDateTime.isAfter(now)) {
      await _setActivityReminderIfReminderNotExist(activity,
          secondReminderDateTime, "${activity.name} startet demnächst.");
    }
  }

  Future<void> _setActivityReminderIfReminderNotExist(
      Activity activity, TZDateTime scheduledDateTime, String message) async {
    bool reminderForActivityExists =
        await _reminderForActivityExists(activity.id!);
    if (!reminderForActivityExists) {
      int notificationReminderId = await _notificationService
          .scheduleNotification(activity.name!, message, scheduledDateTime);
      _saveReminderIdForActivityId(activity.id!, notificationReminderId);
    } else
      logger.i(
          "Activity reminder for activity id ${activity.id!} is already scheduled");
  }

  Future<void> cancelReminderForActivity(String activityId) async {
    List<String>? notificationReminderIds =
        await _prefs.getStringList("${_ACTIVITY_REMINDER_PREFIX}${activityId}");
    if (notificationReminderIds == null) {
      logger.i(
          "activity reminder repository: There are no reminders for the activity with id ${activityId}");
      return;
    }
    logger.i(
        "activity reminder repository: cancel activity reminders for activity with id ${activityId}");
    for (String notificationReminderId in notificationReminderIds) {
      int id = int.tryParse(notificationReminderId) ?? -1;
      await _notificationService.cancelNotification(id);
    }
    (await _prefs.remove("${_ACTIVITY_REMINDER_PREFIX}${activityId}"));
    logger.i("done. canceled all reminders for activity ${activityId}");
  }

  Future<bool> _reminderForActivityExists(String activityId) async {
    List<String>? notificationReminderIds =
        await _prefs.getStringList("${_ACTIVITY_REMINDER_PREFIX}${activityId}");
    return (notificationReminderIds != null);
    //  if (notificationReminderIds == null) return false;
//bool doesReminderExists = notificationReminderIds.contains(activityId);
//    return (doesReminderExists);
  }

  Future<void> _saveReminderIdForActivityId(
      String activityId, int reminderId) async {
    String reminderIdStr = reminderId.toString();
    List<String>? nullableReminderIdListForActivity =
        await _prefs.getStringList("${_ACTIVITY_REMINDER_PREFIX}${activityId}");
    List<String> reminderIdListForActivity =
        nullableReminderIdListForActivity ?? <String>[];
    reminderIdListForActivity.add(reminderIdStr);
    await _prefs.setStringList(
        "${_ACTIVITY_REMINDER_PREFIX}${activityId}", reminderIdListForActivity);

    List<String>? activitiesWithReminder =
        await _prefs.getStringList("${_ACTIVITY_IDS_WITH_REMINDERS_LIST}");

    if (activitiesWithReminder != null) {
      if (!activitiesWithReminder.contains(activityId)) {
        activitiesWithReminder.add(activityId);
        await _prefs.setStringList(
            "${_ACTIVITY_IDS_WITH_REMINDERS_LIST}", activitiesWithReminder);
      }
    } else {
      await _prefs
          .setStringList("${_ACTIVITY_IDS_WITH_REMINDERS_LIST}", [activityId]);
    }
  }
}
