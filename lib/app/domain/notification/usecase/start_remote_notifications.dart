import 'package:peerpal/app/data/notification/device_token_service.dart';
import 'package:peerpal/app/domain/notification/notification_service.dart';
import 'package:peerpal/app_logger.dart';

class StartRemoteNotifications {
  final NotificationService _notificationService;
  final DeviceTokenService _deviceTokenService;
  final _backgroundHandler;
  final _foregroundHandler;

  StartRemoteNotifications({
    required notificationService,
    required deviceTokenService,
    required backgroundHandler,
    required foregroundHandler,
  })  : this._notificationService = notificationService,
        this._backgroundHandler = backgroundHandler,
        this._foregroundHandler = foregroundHandler,
        this._deviceTokenService = deviceTokenService;

  Future<void> call() async {
    logger.i("Start remote notifications.");
    logger.i("Register device token.");
    await _deviceTokenService.registerDeviceToken();
    logger.i("Start remote notification background handler");
    await _notificationService.startRemoteNotificationBackgroundHandler(
        _backgroundHandler, _foregroundHandler);
  }
}
