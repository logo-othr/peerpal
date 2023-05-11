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
  final String _activityReminderPrefixKey = 'ACT_REM_';
  final String _createdActivityIdsWithRemindersKey =
      'createdActivityIdsWithRemindersKey';
  final String _joinedActivityIdsWithRemindersKey =
      'joinedActivityIdsWithRemindersKey';

  LocalActivityReminderRepository(
      {required prefs, required notificationService})
      : _prefs = prefs,
        _notificationService = notificationService;


  Future<List<String>?> getJoinedActivityIdsWithReminders() async {
    return await _prefs.getStringList(_joinedActivityIdsWithRemindersKey);
  }

  Future<void> setJoinedActivityIdsWithReminders(List<String> ids) async {
    await _prefs.setStringList(_joinedActivityIdsWithRemindersKey, ids);
  }

  Future<void> cancelActivityReminders(String activityId) async {
    logger.i("Cancel reminders for ${activityId}");

    List<String>? reminderIds = await _prefs
        .getStringList("${_activityReminderPrefixKey}${activityId}");

    if (reminderIds == null) return;

    for (String notificationReminderId in reminderIds) {
      int id = int.tryParse(notificationReminderId) ?? -1;
      await _notificationService.cancelNotification(id);
    }

    (await _prefs.remove("${_activityReminderPrefixKey}${activityId}"));
  }

  Future<void> setActivityReminders(Activity activity) async {
    // ToDo: Business logic!
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

  /// Deletes all existing reminders associated with the activities that the
  /// current user has joined and sets new reminders for the provided [activities].

  /// Deletes all existing reminders associated with the activities that the
  /// current user has created and sets new reminders for the provided [activities].
  @override
  Future<void> updateCreatedActivitiesReminders(
      List<Activity> activities) async {
    List<String> previousActivityIdsWithReminders =
        await getCreatedActivityIdsWithReminders() ?? [];

    List<String> newIds = activities
        .where((activity) => activity.id != null)
        .map((activity) => activity.id!)
        .toList();

    for (String activityId in previousActivityIdsWithReminders) {
      await cancelActivityReminders(activityId);
    }

    for (Activity activity in activities) {
      await setActivityReminders(activity);
    }

    await setCreatedActivityIdsWithReminders(newIds);
  }

  Future<List<String>?> getCreatedActivityIdsWithReminders() async {
    return await _prefs.getStringList(_createdActivityIdsWithRemindersKey);
  }

  Future<void> setCreatedActivityIdsWithReminders(List<String> ids) async {
    await _prefs.setStringList(_createdActivityIdsWithRemindersKey, ids);
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
    List<String>? notificationReminderIds = await _prefs
        .getStringList("${_activityReminderPrefixKey}${activityId}");
    return (notificationReminderIds != null);
  }

  Future<void> _saveReminder(String activityId, int reminderId) async {
    List<String>? reminderIds = await _readReminderIds(activityId);
    reminderIds.add(reminderId.toString());
    await _writeReminderIds(activityId, reminderIds);
  }

  Future<List<String>> _readReminderIds(String activityId) async {
    List<String>? reminderIds = await _prefs
        .getStringList("${_activityReminderPrefixKey}${activityId}");
    return reminderIds ?? <String>[];
  }

  Future<void> _writeReminderIds(
      String activityId, List<String> reminderIds) async {
    await _prefs.setStringList(
        "${_activityReminderPrefixKey}${activityId}", reminderIds);
  }
}
