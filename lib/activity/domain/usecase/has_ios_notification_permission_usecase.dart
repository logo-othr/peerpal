import 'package:flutter/foundation.dart';
import 'package:peerpal/app/domain/notification/notification_service.dart';

class IsIOSWithoutNotificationPermissionUseCase {
  final NotificationService _notificationService;

  IsIOSWithoutNotificationPermissionUseCase(
    this._notificationService,
  );

  Future<bool> call() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return !(await _notificationService.hasPermission());
    }
    return false;
  }
}
