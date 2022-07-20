import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/tabview/domain/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/src/date_time.dart';
import 'package:timezone/timezone.dart' as tz;

class ActivityReminderRepository {
  final SharedPreferences _prefs;
  final NotificationService _notificationService;
  final String _ACTIVITY_REMINDER_PREFIX = 'ACT_REM_';

  ActivityReminderRepository({required prefs, required notificationService})
      : _prefs = prefs,
        _notificationService = notificationService;

// ToDo: Nullcheck activity member
  Future<void> setRemindersForActivity(Activity activity) async {
    TZDateTime firstReminderDateTime =
        TZDateTime.fromMillisecondsSinceEpoch(tz.local, activity.date!);
    firstReminderDateTime =
        firstReminderDateTime.subtract(new Duration(minutes: 15));
    TZDateTime secondReminderDateTime =
        TZDateTime.fromMillisecondsSinceEpoch(tz.local, activity.date!);
    secondReminderDateTime =
        secondReminderDateTime.subtract(new Duration(hours: 3));
    await _setReminderForActivity(activity, firstReminderDateTime,
        "In 15 Minuten startet deine Aktivität.");
    await _setReminderForActivity(activity, secondReminderDateTime,
        "In 3 Stunden startet deine Aktivität.");
  }

  Future<void> _setReminderForActivity(
      Activity activity, TZDateTime scheduledDateTime, String message) async {
    bool reminderForActivityExists =
        await _reminderForActivityExists(activity.id!);
    if (!reminderForActivityExists) {
      int notificationReminderId =
          await _notificationService.scheduleNotification(activity.name!,
              'Erinnerung an die Aktivität.', scheduledDateTime);
      _saveReminderIdForActivityId(activity.id!, notificationReminderId);
    } else
      print(
          "Activity reminder for activity id ${activity.id!} is already scheduled");
  }

  void cancelReminderForActivity(String activityId) async {} // ToDo: Implement.

  Future<bool> _reminderForActivityExists(String activityId) async {
    List<String>? notificationReminderIds =
        await _prefs.getStringList("${_ACTIVITY_REMINDER_PREFIX}${activityId}");
    if (notificationReminderIds == null) return false;

    return (notificationReminderIds.contains(activityId));
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
  }
}
