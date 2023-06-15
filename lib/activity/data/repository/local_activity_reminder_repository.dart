import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/activity/domain/repository/activity_reminder_repository.dart';
import 'package:peerpal/app/domain/notification/notification_service.dart';
import 'package:peerpal/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/src/date_time.dart';

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

  Future<void> setActivityReminder(
      Activity activity, TZDateTime reminderDate) async {

    await _setActivityReminder(activity, reminderDate,
        "${activity.name?.replaceAll('-', '')} startet demnächst.");
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
    } else {
      // TODO: When the reminder already exists, cancel it and re-schedule it
      logger.i(
          "Activity reminder for activity id ${activity.id!} is already scheduled");
    }
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
