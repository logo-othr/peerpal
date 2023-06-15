import 'package:peerpal/activity/domain/repository/activity_reminder_repository.dart';
import 'package:peerpal/app/domain/notification/notification_service.dart';
import 'package:peerpal/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/src/date_time.dart';

class LocalActivityReminderRepository implements ActivityReminderRepository {
  static const _activityReminderPrefixKey = 'ACT_REM_';
  static const _createdActivityIdsWithRemindersKey =
      'createdActivityIdsWithRemindersKey';
  static const _joinedActivityIdsWithRemindersKey =
      'joinedActivityIdsWithRemindersKey';

  final SharedPreferences _prefs;
  final NotificationService _notificationService;

  LocalActivityReminderRepository({
    required SharedPreferences prefs,
    required NotificationService notificationService,
  })  : _prefs = prefs,
        _notificationService = notificationService;

  Future<List<String>?> getJoinedActivityIdsWithReminders() async =>
      _prefs.getStringList(_joinedActivityIdsWithRemindersKey);

  Future<void> setJoinedActivityIdsWithReminders(List<String> ids) =>
      _prefs.setStringList(_joinedActivityIdsWithRemindersKey, ids);

  Future<void> cancelActivityReminders(String activityId) async {
    logger.i("Cancel reminders for $activityId");

    final reminderIds = await _getReminderIds(activityId);

    if (reminderIds != null) {
      for (final reminderId in reminderIds) {
        final id = int.tryParse(reminderId) ?? -1;
        await _notificationService.cancelNotification(id);
      }
      await _removeReminder(activityId);
    }
  }

  Future<List<String>?> getCreatedActivityIdsWithReminders() async =>
      _prefs.getStringList(_createdActivityIdsWithRemindersKey);

  Future<void> setCreatedActivityIdsWithReminders(List<String> ids) =>
      _prefs.setStringList(_createdActivityIdsWithRemindersKey, ids);

  Future<int> scheduleReminder(
      String activityName, String message, TZDateTime scheduledDateTime) async {
    return await _notificationService.scheduleNotification(
        activityName, message, scheduledDateTime);
  }

  Future<bool> reminderExists(String activityId) async {
    final reminderIds = await _getReminderIds(activityId);
    return reminderIds != null;
  }

  Future<void> saveReminder(String activityId, int reminderId) async {
    final reminderIds = await _getReminderIds(activityId) ?? <String>[];
    reminderIds.add(reminderId.toString());
    await _setReminderIds(activityId, reminderIds);
  }

  Future<List<String>?> _getReminderIds(String activityId) async =>
      _prefs.getStringList("${_activityReminderPrefixKey}$activityId");

  Future<void> _setReminderIds(String activityId, List<String> reminderIds) =>
      _prefs.setStringList(
          "${_activityReminderPrefixKey}$activityId", reminderIds);

  Future<void> _removeReminder(String activityId) =>
      _prefs.remove("${_activityReminderPrefixKey}$activityId");
}
