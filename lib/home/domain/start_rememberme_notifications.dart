import 'package:peerpal/app_logger.dart';
import 'package:peerpal/home/data/rememberme_notification_repository.dart';

class StartRememberMeNotifications {
  RememberMeNotificationRepository _rememberMeNotificationRepository;

  StartRememberMeNotifications({
    required rememberMeNotificationRepository,
  }) : this._rememberMeNotificationRepository =
            rememberMeNotificationRepository;

  Future<void> call() async {
    logger.i("Activate weekly reminders");
    _rememberMeNotificationRepository.activateReminders();
  }
}
