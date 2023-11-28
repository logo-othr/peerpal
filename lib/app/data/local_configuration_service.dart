import 'package:peerpal/app/data/configuration_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalConfigurationService implements ConfigurationService {
  Future<void> setWeeklyReminderNotificationId(int notificationId) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.setInt("weekly-reminder", notificationId);
  }

  Future<int?> getWeeklyReminderNotificationId() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    int? isWeeklyReminderScheduled = prefs.getInt("weekly-reminder");
    return isWeeklyReminderScheduled;
  }
}
