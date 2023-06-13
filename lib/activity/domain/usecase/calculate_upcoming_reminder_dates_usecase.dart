import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:timezone/timezone.dart' as tz;

class CalculateUpcomingReminderDatesUseCase {
  static const int _minutesBeforeActivity2 = 60;
  static const int _daysBeforeActivity1 = 1;

  Future<List<tz.TZDateTime>> call(Activity activity) async {
    final reminder2Date = _calculateReminder2Date(activity);
    final reminder1Date = _calculateReminder1Date(activity);

    List<tz.TZDateTime> upcomingReminders = [];

    if (_isUpcoming(reminder2Date)) {
      upcomingReminders.add(reminder2Date);
    }
    if (_isUpcoming(reminder1Date)) {
      upcomingReminders.add(reminder1Date);
    }

    return upcomingReminders;
  }

  tz.TZDateTime _calculateReminder2Date(Activity activity) {
    final reminder2Date =
        tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, activity.date!);
    return reminder2Date.subtract(Duration(minutes: _minutesBeforeActivity2));
  }

  tz.TZDateTime _calculateReminder1Date(Activity activity) {
    final reminder1Date =
        tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, activity.date!);
    return reminder1Date.subtract(Duration(days: _daysBeforeActivity1));
  }

  bool _isUpcoming(tz.TZDateTime dateTime) {
    return dateTime.isAfter(tz.TZDateTime.from(DateTime.now(), tz.local));
  }
}
