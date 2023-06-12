import 'package:flutter/foundation.dart';
import 'package:peerpal/app/domain/notification/notification_service.dart';

class HasIOSNotificationPermissionUseCase {
  final NotificationService _notificationService;

  HasIOSNotificationPermissionUseCase(
    this._notificationService,
  );

  Future<bool> call() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return await _notificationService.hasPermission();
    }
    return false;
  }
}
