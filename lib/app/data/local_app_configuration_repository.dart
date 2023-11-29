import 'package:peerpal/app/data/app_configuration_repository';
import 'package:shared_preferences/shared_preferences.dart';

class LocalAppConfigurationRepository implements AppConfigurationRepository {
  final String HAS_ASKED_FOR_PERMISSION = "HAS_ASKED_FOR_PERMISSION";

  @override
  Future<void> setWeeklyReminderNotificationId(int notificationId) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.setInt("weekly-reminder", notificationId);
  }

  @override
  Future<int?> getWeeklyReminderNotificationId() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    int? isWeeklyReminderScheduled = prefs.getInt("weekly-reminder");
    return isWeeklyReminderScheduled;
  }

  @override
  Future<bool> hasAskedForPermission() async {
    final SharedPreferences _preferences =
        await SharedPreferences.getInstance();
    return await _preferences.getBool(HAS_ASKED_FOR_PERMISSION) ?? false;
  }

  @override
  Future<void> setAskedForNotificationPermission(bool hasAsked) async {
    final SharedPreferences _preferences =
        await SharedPreferences.getInstance();
    await _preferences.setBool(HAS_ASKED_FOR_PERMISSION, hasAsked);
  }
}
