import 'package:peerpal/account_setup/data/rememberme_notification_repository.dart';
import 'package:peerpal/app_logger.dart';

class StartRememberMeNotifications {
  RememberMeNotificationRepository _rememberMeNotificationRepository;

  StartRememberMeNotifications({
    required rememberMeNotificationRepository,
  }) : this._rememberMeNotificationRepository =
            rememberMeNotificationRepository;

  Future<void> call() async {
    logger.i("Activate weekly reminders");
    _rememberMeNotificationRepository.scheduleWeeklyReminders(
        'Wöchentliche Erinnerung - PeerPAL',
        'Hi, wir würden uns freuen, wenn du PeerPAL diese Woche nutzt!');
  }
}
