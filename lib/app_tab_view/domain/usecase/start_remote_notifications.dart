import 'package:peerpal/app_tab_view/domain/notification_service.dart';

class StartRemoteNotifications {
  NotificationService _notificationService;
  var _remoteNotificationBackgroundHandler;

  StartRemoteNotifications(
      {required notificationService,
      required remoteNotificationBackgroundHandler})
      : this._notificationService = notificationService,
        this._remoteNotificationBackgroundHandler =
            remoteNotificationBackgroundHandler;

  Future<void> call() async {
    await _notificationService.registerDeviceToken();
    await _notificationService.startRemoteNotificationBackgroundHandler(
        _remoteNotificationBackgroundHandler);
  }
}
