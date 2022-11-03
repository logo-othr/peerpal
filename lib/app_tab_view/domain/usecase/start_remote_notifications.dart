import 'package:peerpal/app_logger.dart';
import 'package:peerpal/app_tab_view/domain/notification_service.dart';

class StartRemoteNotifications {
  NotificationService _notificationService;
  var _remoteNotificationBackgroundHandler;
  var _remoteNotificationForegroundHandler;

  StartRemoteNotifications(
      {required notificationService,
      required remoteNotificationBackgroundHandler,
      required remoteNotificationForegroundHandler})
      : this._notificationService = notificationService,
        this._remoteNotificationBackgroundHandler =
            remoteNotificationBackgroundHandler,
        this._remoteNotificationForegroundHandler =
            remoteNotificationForegroundHandler;

  Future<void> call() async {
    logger.i("Start remote notifications.");
    logger.i("Register device token.");
    await _notificationService.registerDeviceToken();
    logger.i("Start remote notification background handler");
    await _notificationService.startRemoteNotificationBackgroundHandler(
        _remoteNotificationBackgroundHandler,
        _remoteNotificationForegroundHandler);
  }
}
