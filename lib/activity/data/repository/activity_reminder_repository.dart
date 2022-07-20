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
  Future<void> setReminderForActivity(Activity activity) async {
    TZDateTime scheduledDateTime =
        TZDateTime.fromMillisecondsSinceEpoch(tz.local, activity.date!);
    scheduledDateTime = scheduledDateTime.subtract(new Duration(minutes: 15));
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
    int? notificationReminderId =
        await _prefs.getInt("${_ACTIVITY_REMINDER_PREFIX}${activityId}");
    return (notificationReminderId != null);
  }

  Future<void> _saveReminderIdForActivityId(
      String activityId, int reminderId) async {
    await _prefs.setInt(
        "${_ACTIVITY_REMINDER_PREFIX}${activityId}", reminderId);
  }
}
