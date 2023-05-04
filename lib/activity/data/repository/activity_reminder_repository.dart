import 'dart:io';

import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/activity/domain/repository/activity_reminder_repository.dart';
import 'package:peerpal/app/domain/notification/notification_service.dart';
import 'package:peerpal/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/src/date_time.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalActivityReminderRepository implements ActivityReminderRepository {
  final SharedPreferences _prefs;
  final NotificationService _notificationService;
  final String _ACTIVITY_REMINDER_PREFIX = 'ACT_REM_';
  final String _ACTIVITY_IDS_WITH_REMINDERS_LIST =
      '_ACTIVITY_IDS_WITH_REMINDERS_LIST';

  LocalActivityReminderRepository(
      {required prefs, required notificationService})
      : _prefs = prefs,
        _notificationService = notificationService;

  Future<void> setAllReminders(List<Activity> activities) async {
    List<String>? oldActivityWithReminderList =
        await _prefs.getStringList("${_ACTIVITY_IDS_WITH_REMINDERS_LIST}");

    List<String> newActivityWithReminderList =
        activities.map((e) => e.id ?? "-1").toList();

    if (oldActivityWithReminderList != null) {
      for (String oldActivity in oldActivityWithReminderList) {
        if (!newActivityWithReminderList.contains(oldActivity)) {
          await cancelActivityReminders(oldActivity);
          (await _prefs.setStringList(
              _ACTIVITY_IDS_WITH_REMINDERS_LIST, newActivityWithReminderList));
        }
      }
    }

    for (Activity activity in activities) {
      await setActivityReminders(activity);
    }
  }

  Future<void> cancelActivityReminders(String activityId) async {
    List<String>? reminderIds =
        await _prefs.getStringList("${_ACTIVITY_REMINDER_PREFIX}${activityId}");
    if (reminderIds == null) {
      logger.i(
          "activity reminder repository: There are no reminders for the activity with id ${activityId}");
      return;
    }
    logger.i(
        "activity reminder repository: cancel activity reminders for activity with id ${activityId}");
    for (String notificationReminderId in reminderIds) {
      int id = int.tryParse(notificationReminderId) ?? -1;
      await _notificationService.cancelNotification(id);
    }
    (await _prefs.remove("${_ACTIVITY_REMINDER_PREFIX}${activityId}"));
    logger.i("done. canceled all reminders for activity ${activityId}");
  }

  Future<void> setActivityReminders(Activity activity) async {
    if (Platform.isIOS && await _notificationService.hasPermission() == false)
      return;

    int minutesBeforeActivity2 = 60;
    int daysBeforeActivity1 = 1;

    TZDateTime reminder2date =
        TZDateTime.fromMillisecondsSinceEpoch(tz.local, activity.date!);
    reminder2date =
        reminder2date.subtract(new Duration(minutes: minutesBeforeActivity2));

    TZDateTime reminder1date =
        TZDateTime.fromMillisecondsSinceEpoch(tz.local, activity.date!);
    reminder1date =
        reminder1date.subtract(new Duration(days: daysBeforeActivity1));
    TZDateTime now = tz.TZDateTime.from(DateTime.now(), tz.local);

    if (reminder2date.isAfter(now)) {
      await _setActivityReminder(activity, reminder2date,
          "Bald startet die Aktivität ${activity.name?.replaceAll('-', '')}.");
    }
    if (reminder1date.isAfter(now)) {
      await _setActivityReminder(activity, reminder1date,
          "${activity.name?.replaceAll('-', '')} startet demnächst.");
    }
  }

  Future<void> _setActivityReminder(
      Activity activity, TZDateTime scheduledDateTime, String message) async {
    bool reminderExists = await _reminderExists(activity.id!);
    if (!reminderExists) {
      int reminderId = await _notificationService.scheduleNotification(
          activity.name!, message, scheduledDateTime);
      _saveReminder(activity.id!, reminderId);
    } else
      logger.i(
          "Activity reminder for activity id ${activity.id!} is already scheduled");
  }

  Future<bool> _reminderExists(String activityId) async {
    List<String>? notificationReminderIds =
        await _prefs.getStringList("${_ACTIVITY_REMINDER_PREFIX}${activityId}");
    return (notificationReminderIds != null);
  }

  Future<List<String>> _getReminderIds(String activityId) async {
    List<String>? reminderIds =
        await _prefs.getStringList("${_ACTIVITY_REMINDER_PREFIX}${activityId}");
    return reminderIds ?? <String>[];
  }

  Future<void> _setReminderIds(
      String activityId, List<String> reminderIds) async {
    await _prefs.setStringList(
        "${_ACTIVITY_REMINDER_PREFIX}${activityId}", reminderIds);
  }

  Future<List<String>> _getActivityIdsWithReminder() async {
    List<String>? activityIds =
        await _prefs.getStringList("${_ACTIVITY_IDS_WITH_REMINDERS_LIST}");
    return activityIds ?? <String>[];
  }

  Future<void> _setActivityIdsWithReminder(
      List<String> activityIdsWithReminders) async {
    await _prefs.setStringList(
        "${_ACTIVITY_IDS_WITH_REMINDERS_LIST}", activityIdsWithReminders);
  }

  Future<void> _saveReminder(String activityId, int reminderId) async {
    List<String>? reminderIds = await _getReminderIds(activityId);
    reminderIds.add(reminderId.toString());
    await _setReminderIds(activityId, reminderIds);

    List<String>? activityIdsWithReminders =
        await _getActivityIdsWithReminder();

    if (!activityIdsWithReminders.contains(activityId)) {
      activityIdsWithReminders.add(activityId);
      await _setActivityIdsWithReminder(activityIdsWithReminders);
    }
  }
}
