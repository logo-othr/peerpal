import 'package:peerpal/app/data/local_app_configuration_service.dart';

class LocalAppReminderRepository {
  final LocalAppConfigurationService _localConfiguration;

  LocalAppReminderRepository({required localConfiguration})
      : _localConfiguration = localConfiguration;

  Future<int?> getWeeklyReminderNotificationId() async {
    return await _localConfiguration.getWeeklyReminderNotificationId();
  }

  @override
  Future<void> setWeeklyReminderNotificationId(int id) async {
    await _localConfiguration.setWeeklyReminderNotificationId(id);
  }
}
