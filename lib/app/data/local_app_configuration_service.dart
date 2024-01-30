import 'package:peerpal/app/data/app_configuration_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalAppConfigurationService implements AppConfigurationService {
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

  @override
  Future<bool> isNotificationPermissionRequested() async {
    final SharedPreferences _preferences =
        await SharedPreferences.getInstance();
    return await _preferences.getBool("notification-permission-requested") ??
        false;
  }

  @override
  Future<void> setNotificationPermissionRequested() async {
    final SharedPreferences _preferences =
        await SharedPreferences.getInstance();
    await _preferences.setBool("notification-permission-requested", true);
  }
}
