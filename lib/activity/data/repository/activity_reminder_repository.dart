import 'package:peerpal/notification_service.dart';
import 'package:peerpal/repository/models/activity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/src/date_time.dart';
import 'package:timezone/timezone.dart' as tz;

class ActivityReminderRepository {
  final SharedPreferences _prefs;
  final NotificationService _notificationService;

  ActivityReminderRepository({required prefs, required notificationService})
      : _prefs = prefs,
        _notificationService = notificationService;

// ToDo: Nullcheck activity member
  void setReminderForActivity(Activity activity) async {
    TZDateTime scheduledDateTime = TZDateTime.fromMillisecondsSinceEpoch(
        tz.local, int.parse(activity.timestamp!));

    int notificationId = await _notificationService.scheduleNotification(
        activity.name!, 'Erinnerung an die Aktivität.', scheduledDateTime);
  }

  cancelReminderForActivity(String activityId) {}
}
