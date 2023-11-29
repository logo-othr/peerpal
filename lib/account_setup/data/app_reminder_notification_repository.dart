import 'package:peerpal/account_setup/domain/app_reminder_repository.dart';
import 'package:peerpal/app/data/local_app_configuration_service.dart';

class LocalAppReminderRepository implements AppReminderRepository {
  final LocalAppConfigurationService _localConfiguration;

  LocalAppReminderRepository({required localConfiguration})
      : _localConfiguration = localConfiguration;

  @override
  Future<int?> getWeeklyReminderNotificationId() async {
    return await _localConfiguration.getWeeklyReminderNotificationId();
  }

  @override
  Future<void> setWeeklyReminderNotificationId(int id) async {
    await _localConfiguration.setWeeklyReminderNotificationId(id);
  }
}
